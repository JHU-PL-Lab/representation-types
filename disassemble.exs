

defmodule Disassemble do
  def main() do
    [src | _] = System.argv()
    [{_, code}|_] = Code.require_file(src)
    b = :beam_disasm.file(code)
    IO.inspect(b, pretty: true)
  end
end

Disassemble.main()
