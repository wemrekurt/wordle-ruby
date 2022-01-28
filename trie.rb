class TrieNode
  attr_accessor :children, :end_of_word, :parent

  def initialize(parent)
    self.children = {}
    self.parent = parent
    self.end_of_word = false
  end
end

class Trie
  attr_accessor :root

  def initialize
    self.root = node
  end

  def node(prnt = nil)
    TrieNode.new(prnt)
  end

  def char_to_index(letter)
    letter.ord
  end

  def insert(word)
    word.downcase!
    p_crawl = root
    word.each_char do |letter|
      index = letter.ord
      p_crawl.children[index] = node(p_crawl) unless p_crawl.children[index]
      p_crawl = p_crawl.children[index]
    end
    p_crawl.end_of_word = true
  end

  def search(word)
    word.downcase!
    p_crawl = root
    word.each_char do |letter|
      if p_crawl.children[letter.ord]
        p_crawl = p_crawl.children[letter.ord]
        next
      end
      return false
    end
    p_crawl.end_of_word
  end

  def to_s
    visualize(root, '_', 0)
  end

  def visualize(item, letter, level)
    ret = (' ' * level) + "#{letter.chr} \n"
    item.children.each do |ltr, child|
      ret += visualize(child, ltr, level + 1)
    end
    ret
  end
end
