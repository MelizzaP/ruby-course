
class Book
  attr_reader :author, :title
  attr_accessor :status, :id, :borrower
  
  def initialize(title, author)
    @title = title
    @author = author
    @id = nil
    @status = 'available'
    @borrower = nil
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
  attr_reader :books, :counter
  
  def initialize(name)
    @books = []
    @counter = 0
  end

  def add_book(title, author)
    title = Book.new(title,author)
    title.id = counter 
    @books << title
    @counter +=1
  end

  def check_out_book(book_id, borrower)
    selected_book = @books.find {|book| book.id == book_id}
    if selected_book.check_out
      selected_book.borrower = borrower
      selected_book
    end
  end
  
  def get_borrower(book_id)
    selected_book = @books.find {|book| book.id == book_id}
    selected_book.borrower.name
  end
  
  def check_in_book(book)
    selected_book = @books.find {|books| books == book}
    selected_book.check_in 
  end

  def available_books
  end

  def borrowed_books
  end
end
