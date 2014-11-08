module Utf8Util
  # cursesとmrubyでutf8のコードの扱いが違うのでmruby用に変換する
  # 具体的にはcursesでは制御コード込みの各オクテットの10進数
  # mrubyでは制御コードを除いた全体の10進数
  def self.convert_utf_code(inputs)
    if inputs.size == 1
      input = inputs[0]
    elsif inputs.size == 2
      first  = inputs[0].to_s(2)[3,5]
      second = inputs[1].to_s(2)[2,6]
      input = "#{first}#{second}".to_i(2)
    elsif inputs.size == 3
      first  = inputs[0].to_s(2)[4,4]
      second = inputs[1].to_s(2)[2,6]
      third  = inputs[2].to_s(2)[2,6]
      input = "#{first}#{second}#{third}".to_i(2)
    elsif inputs.size == 4
      first  = inputs[0].to_s(2)[5,3]
      second = inputs[1].to_s(2)[2,6]
      third  = inputs[2].to_s(2)[2,6]
      force  = inputs[3].to_s(2)[2,6]
      input = "#{first}#{second}#{third}#{force}".to_i(2)
    end
  end

  def self.multibyte?(char)
    return false if char.bytesize == 1
    input = self.convert_utf_code(char.bytes)
    # 半角カナ
    return false if (65377 <= input && input <= 65439)
    return true
  end

end
