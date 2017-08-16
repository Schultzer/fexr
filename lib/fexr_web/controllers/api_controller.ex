defmodule FexrWeb.ApiController do
  use FexrWeb, :controller

  def latest(conn, params) do
    conn
    |> put_status(:ok)
    |> json(validate_params(params, :latest))
  end

  def historical(conn, params) do
    conn
    |> put_status(:ok)
    |> json(validate_params(params, :historical))
  end

  def validate_params(%{"base" => base, "date" => date, "symbols" => symbols} = params, :historical) do
    ConCache.get_or_store(:historical, "#{date}/#{base}/#{symbols}", fn ->
      iso = FexrImf.symbols

      params
      |> validate_date
      |> validate_base(iso)
      |> validate_symbols(iso)
      |> template(:historical)
    end)
  end
  def validate_params(%{"base" => base, "date" => date} = params, :historical) do
    ConCache.get_or_store(:historical, "#{date}/#{base}", fn ->
      iso = FexrImf.symbols

      params
      |> Map.put("symbols", nil)
      |> validate_date
      |> validate_base(iso)
      |> validate_symbols(iso)
      |> template(:historical)
    end)
  end
  def validate_params(%{"date" => date, "symbols" => symbols} = params, :historical) do
    ConCache.get_or_store(:historical, "#{date}/USD/#{symbols}", fn ->
      iso = FexrImf.symbols

      params
      |> Map.put("base", "USD")
      |> validate_date
      |> validate_base(iso)
      |> validate_symbols(iso)
      |> template(:historical)
    end)
  end
  def validate_params(%{"date" => date} = params, :historical) do
    ConCache.get_or_store(:historical, "#{date}/USD", fn ->
      iso = FexrImf.symbols

      params
      |> Map.put("base", "USD")
      |> Map.put("symbols", nil)
      |> validate_date
      |> validate_base(iso)
      |> validate_symbols(iso)
      |> template(:historical)
    end)
  end
  def validate_params(%{"base" => base, "symbols" => symbols} = params, :latest) do
    ConCache.get_or_store(:latest, "#{base}/#{symbols}", fn ->
      iso = FexrYahoo.symbols
      date = Date.to_string(Date.utc_today)

      params
      |> Map.put("date", date)
      |> validate_date
      |> validate_base(iso)
      |> validate_symbols(iso)
      |> template(:latest)
    end)
  end
  def validate_params(%{"base" => base} = params, :latest) do
    ConCache.get_or_store(:latest, "#{base}", fn ->
      iso = FexrYahoo.symbols
      date = Date.to_string(Date.utc_today)

      params
      |> Map.put("date", date)
      |> Map.put("symbols", nil)
      |> validate_date
      |> validate_base(iso)
      |> validate_symbols(iso)
      |> template(:latest)
    end)
  end
  def validate_params(%{"symbols" => symbols} = params, :latest) do
    ConCache.get_or_store(:latest, "USD/#{symbols}", fn ->
      iso = FexrYahoo.symbols
      date = Date.to_string(Date.utc_today)

      params
      |> Map.put("date", date)
      |> Map.put("base", "USD")
      |> validate_date
      |> validate_base(iso)
      |> validate_symbols(iso)
      |> template(:latest)
    end)
  end
  def validate_params(%{} = params, :latest) do
    ConCache.get_or_store(:latest, "USD", fn ->
      iso = FexrYahoo.symbols
      date = Date.to_string(Date.utc_today)

      params
      |> Map.put("base", "USD")
      |> Map.put("date", date)
      |> Map.put("symbols", nil)
      |> validate_date
      |> validate_base(iso)
      |> validate_symbols(iso)
      |> template(:latest)
    end)
  end



  def validate_date([year, month, day], %{"base" => base, "date" => _date, "symbols" => symbols}) do
    year     = String.to_integer(year)
    month    = String.to_integer(month)
    day      = String.to_integer(day)
    today    = Date.utc_today
    tomorrow = Date.add(today, 1) |> Date.to_erl
    date     = {year, month, day}


    err_msg = %{"error" => "Not found"}
    cond do
      year < 1995               -> {:error, err_msg}
      year > today.year         -> {:error, err_msg}
      month > 12                -> {:error, err_msg}
      month == 0                -> {:error, err_msg}
      day > 31                  -> {:error, err_msg}
      day == 0                  -> {:error, err_msg}
      date == tomorrow          -> {:error, err_msg}
      date > Date.to_erl(today) -> {:error, err_msg}
      true                      -> %{"base" => base, "date" => date, "symbols" => symbols}
    end
  end
  def validate_date(_list, _params), do: {:error, %{"error" => "Not found"}}
  def validate_date(%{"base" => _base, "date" => date, "symbols" => _symbols} = params) when is_binary(date), do: date |> String.split("-") |> validate_date(params)
  def validate_date(_params), do: {:error, %{"error" => "Not found"}}


  def validate_base({:error, err_msg}), do: {:error, err_msg}
  def validate_base(true, params), do: params
  def validate_base(false, _params), do: {:error, %{"error" => "Invalid base"}}
  def validate_base(params, iso), do: Enum.member?(iso, params["base"]) |> validate_base(params)

  def validate_symbols({:error, err_msg}, _iso), do: {:error, err_msg}
  def validate_symbols(%{"base" => _base, "date" => _date, "symbols" => nil} = params, _iso), do: params
  def validate_symbols(%{"base" => base, "date" => date, "symbols" => symbols}, iso) do
    results = for symbol <- String.split(symbols, ","), do: Enum.member?(iso, symbol)
    case Enum.member?(results, false) do
      true  -> {:error, %{"error" => "Invalid symbols"}}
      false -> %{"base" => base, "date" => date, "symbols" => String.split(symbols, ",")}
    end
  end

  def template(%{"base" => base, "date" => date, "symbols" => nil}, :latest) do
    datestring = date |> Date.from_erl! |> Date.to_string
    rates = FexrYahoo.rates(base)
    %{"base" => base, "date" => datestring, "rates" => rates}
  end
  def template(%{"base" => base, "date" => date, "symbols" => symbols}, :latest) do
    datestring = date |> Date.from_erl! |> Date.to_string
    rates = FexrYahoo.rates(base, symbols)
    %{"base" => base, "date" => datestring, "rates" => rates}
  end
  def template(%{"base" => base, "date" => date, "symbols" => nil}, :historical) do
    datestring = date |> Date.from_erl! |> Date.to_string
    rates = FexrImf.rates(date, base)
    if Enum.all?(Map.values(rates), fn(x) -> x == "NA" end), do: %{"error" => "Not found"}, else: %{"base" => base, "date" => datestring, "rates" => rates}
  end
  def template(%{"base" => base, "date" => date, "symbols" => symbols}, :historical) do
    datestring = date |> Date.from_erl! |> Date.to_string
    rates = FexrImf.rates(date, base, symbols)
    if Enum.all?(Map.values(rates), fn(x) -> x == "NA" end), do: %{"error" => "Not found"}, else: %{"base" => base, "date" => datestring, "rates" => rates}
  end
  def template({:error, err_msg}, _), do: err_msg
  def template(_params, _), do: %{"error" => "Invalid request"}
end
