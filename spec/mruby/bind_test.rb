class BindTest < MTest::Unit::TestCase
	require './mruby/bind'

	def test_initialize
		bind = Bind.new
		assert_instance_of(Bind, bind)
	end

	def test_add
		bind = Bind.new
		bind['a'] = true
		assert bind['a']
	end

	def test_key?
		bind = Bind.new
		bind['a'] = true
		assert bind['a']
	end

	def test_has_proc?
		bind = Bind.new
		bind.proc do
			true
		end

		assert bind.has_proc?
	end

	def test_call
		bind = Bind.new
		bind.proc do
			true
		end

		assert bind.call
	end
end

MTest::Unit.new.run
