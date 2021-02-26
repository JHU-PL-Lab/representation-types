
defmodule Matrix do

  def mat4x4_col(col, m) do
    for {row, vec} <- m, into: %{}, do: {row, vec[col]}
  end

  def vec4_dot(v1, v2) do
    v1.x*v2.x + v1.y*v2.y + v1.z*v2.z + v1.w*v2.w
  end

  def mat4x4_mul_row(v1, m1) do
    for col <- [:x,:y,:z,:w], into: %{} do
      {col, vec4_dot(v1, mat4x4_col(col, m1))}
    end
  end

  def mat4x4_mul(m1, m2) do
    for row <- [:x,:y,:z,:w], into: %{} do
      {row, mat4x4_mul_row(m1[row], m2)}
    end
  end


  def mat4x4_det(m) do
    m.x.w * m.y.z * m.z.y * m.w.x  -  m.x.z * m.y.w * m.z.y * m.w.x  -  m.x.w * m.y.y * m.z.z * m.w.x +
    m.x.y * m.y.w * m.z.z * m.w.x  +  m.x.z * m.y.y * m.z.w * m.w.x  -  m.x.y * m.y.z * m.z.w * m.w.x -
    m.x.w * m.y.z * m.z.x * m.w.y  +  m.x.z * m.y.w * m.z.x * m.w.y  +  m.x.w * m.y.x * m.z.z * m.w.y -
    m.x.x * m.y.w * m.z.z * m.w.y  -  m.x.z * m.y.x * m.z.w * m.w.y  +  m.x.x * m.y.z * m.z.w * m.w.y +
    m.x.w * m.y.y * m.z.x * m.w.z  -  m.x.y * m.y.w * m.z.x * m.w.z  -  m.x.w * m.y.x * m.z.y * m.w.z +
    m.x.x * m.y.w * m.z.y * m.w.z  +  m.x.y * m.y.x * m.z.w * m.w.z  -  m.x.x * m.y.y * m.z.w * m.w.z -
    m.x.z * m.y.y * m.z.x * m.w.w  +  m.x.y * m.y.z * m.z.x * m.w.w  +  m.x.z * m.y.x * m.z.y * m.w.w -
    m.x.x * m.y.z * m.z.y * m.w.w  -  m.x.y * m.y.x * m.z.z * m.w.w  +  m.x.x * m.y.y * m.z.z * m.w.w
  end

  def mat4x4_input() do
    dims = [:x,:y,:z,:w]
    for row <- dims, into: %{} do
      cols = IO.binread(:line)
        |> String.split()
        |> Enum.map(&String.to_integer/1)
      { row, Enum.zip(dims, cols) |> Map.new }
    end
  end


  def loop(m1, m2, m3, n) do
    det = mat4x4_mul(m1, mat4x4_mul(m2, m3)) |> mat4x4_det
    if n == 1 do
      IO.puts(Integer.to_string(det))
    else
      loop(m1, m2, m3, n-1)
    end
  end

  def main() do
    num_reps = IO.binread(:line)
      |> String.trim()
      |> String.to_integer

    m1 = mat4x4_input()
    m2 = mat4x4_input()
    m3 = mat4x4_input()

    loop(m1, m2, m3, num_reps)
  end

end


Matrix.main()
