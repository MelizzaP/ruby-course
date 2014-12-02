
class Book
  attr_reader :author, :title
  attr_accessor :status, :id
  
  def initialize(title, author)
    @title = title
    @author = author
    @id = nil
    @status = 'available'
  end
  
# This function will return false if the book 
#   is already checked out, true if available
  def check_out 
    if status == 'available'
      @status = 'checked_out'
      true
    else 
      false 
    end   
  end
  
  def check_in 
    @status = 'available'
  end
  
end

class Borrower
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
end

class Library
  attr_reader :books, :counts
  
  def initialize(name)
    @books = []
    @counts = 0
  end

  def add_book(title, author)
    title = Book.new(title,author)
    title.id = count 
    @books << title
    @counts +=1
  end

  def check_out_book(book_id, borrower)
  end

  def check_in_book(book)
  end

  def available_books
  end

  def borrowed_books
  end
end
