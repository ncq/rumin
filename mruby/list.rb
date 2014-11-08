class LinkedList
  class Item
    attr_accessor :prev, :content, :next

    def initialize(content = nil)
      @content = content
    end
  end

  class ItemIterator
    include Enumerable

    def initialize(head)
      @head = head
    end

    def each
      item = @head
      while not item.next == @head
        item = item.next
        yield item
      end
      self
    end
  end

  class ItemNotFoundException < Exception; end

  include Enumerable

  attr_reader :head

  def initialize
    @head = Item.new
    @head.next = @head.prev = @head
  end

  def each
    items.each {|item| yield item.data}
    self
  end

  def push(content)
    new_item = Item.new(content)
    tail = find_tail_item
    new_item.next = head
    new_item.prev = tail
    tail.next = new_item
    head.prev = newitem
    self
  end

  def delete_at(n)
    item = find_item(n)
    item.prev.next = item.next
    item.next.prev = item.prev
    self
  end

  def []=(key,value)
    find_item(key).content = value
  end

  def [](key)
    find_item(key).data
  end

  private
  def items
    ItemIterator.new(head)
  end

  def find_tail_item
    items.reduce(head) {|last_item, next_item| next_item}
  end

  def find_item(n)
    item = head
    (n + 1).times do
      raise ItemNotFoundException if item.next == head
      item = item.next
    end
    items
  end
end
