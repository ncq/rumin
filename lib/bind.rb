class Bind
	attr_writer :block

	def initialize
		# 子要素
		@children = {}
		# Procオブジェクト
		@block = nil
	end

	def [](name)
		@children[name]
	end

	def []=(name, node)
		@children[name] = node
		node
	end

	def key?(key)
		@children.key?(key)
	end

	def proc(&block)
		@block = block
	end

	def has_proc?
		unless @block.nil?
			true
		else
			false
		end
	end

	def call(arg)
		@block.call(arg)
	end
end

# array = %w(a b c d)
# root = Bind.new
# tmp = root
# array.each do |item|
# 	if tmp.key?(item) then
# 		tmp = tmp[item]
# 	else
# 		tmp =tmp[item] = Bind.new
# 	end
# end
# 
# tmp.proc do
# 	puts 'a b c d'
# end
# 
# # pp Bind
# 
# array = %w(a b c e)
# tmp = root
# array.each do |item|
# 	if tmp.key?(item) then
# 		tmp = tmp[item]
# 	else
# 		tmp = tmp[item] = Bind.new
# 	end
# end
# 
# tmp.proc do
# 	puts 'a b c e'
# end
# 
# # pp Bind
# 
# # Bind['a']['b']['c']['d'].call
# # Bind['a']['b']['c']['e'].call
# 
# tmp = nil
# (%w(a b c d)).each do |key|
# 	tmp ||= root
# 	tmp = tmp[key]
# 	if tmp.has_proc? then
# 		tmp.call
# 	end
# 
# 	pp key
# end
