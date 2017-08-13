defmodule FexrWeb.ApiControllerTest do
  use FexrWeb.ConnCase
  import FexrWeb.ApiController

  @imf FexrImf.symbols
  @yahoo FexrYahoo.symbols
  @base_ok %{"base" => "USD", "date" => "2017-08-08", "symbols" => nil}
  @base_err %{"base" => "d", "date" => "2017-08-08", "symbols" => nil}
  @date_ok %{"base" => "USD", "date" => "2017-08-08", "symbols" => nil}
  @date_err %{"base" => "EUR", "date" => "2017", "symbols" => nil}
  @symbols_ok %{"base" => "EUR", "date" => "2017-08-08", "symbols" => "DKK,PEN,USD"}
  @symbols_err %{"base" => "EUR", "date" => "2017-08-08", "symbols" => "kkd, nep, dsu"}


  test "validate_date/1" do
    assert validate_date(@date_ok)  == %{"base" => "USD", "date" => {2017, 08, 08}, "symbols" => nil}
    assert validate_date(@date_err)  == {:error, %{"error" => "Not found"}}
  end

  test "validate_base/2" do
    assert validate_base(@base_ok, @imf) == %{"base" => "USD", "date" => "2017-08-08", "symbols" => nil}
    assert validate_base(@base_err, @imf) == {:error, %{"error" => "Invalid base"}}

    assert validate_base(@base_ok, @yahoo) == %{"base" => "USD", "date" => "2017-08-08", "symbols" => nil}
    assert validate_base(@base_err, @yahoo) == {:error, %{"error" => "Invalid base"}}
  end

  test "validate_symbols/2" do
    assert validate_symbols(@symbols_ok, @imf) == %{"base" => "EUR", "date" => "2017-08-08", "symbols" => ["DKK", "PEN", "USD"]}
    assert validate_symbols(@symbols_err, @imf) == {:error, %{"error" => "Invalid symbols"}}

    assert validate_symbols(@symbols_ok, @yahoo) == %{"base" => "EUR", "date" => "2017-08-08", "symbols" => ["DKK", "PEN", "USD"]}
    assert validate_symbols(@symbols_err, @yahoo) == {:error, %{"error" => "Invalid symbols"}}
  end
end
