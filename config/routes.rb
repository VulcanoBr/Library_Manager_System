Rails.application.routes.draw do

  devise_for :admins , controllers: { sessions: 'admins/sessions' , registrations: 'admins/registrations'}
  devise_for :librarians, controllers: { sessions: 'librarians/sessions' , registrations: 'librarians/registrations'}
  devise_for :students, controllers: { sessions: 'students/sessions' , registrations: 'students/registrations'}

  resources :transactions
  resources :libraries
  resources :books
  resources :nationalities
  resources :authors
  resources :publishers
  resources :home_pages
  resources :education_levels
  resources :languages
  resources :subjects

  resources :admins do
    get 'list_checkedoutBooksAndStudents', on: :collection, as: :list_checkedoutBooksAndStudents
    get 'list_checkedoutBooks', on: :collection, as: :list_checkedoutBooks
    get 'getOverdueBooks', on: :collection, as: :getOverdueBooks
    get 'viewHoldRequest', on: :collection, as: :viewHoldRequest
    get 'viewBookHistory', on: :collection, as: :viewBookHistory
    get 'show_books', on: :collection, as: :show_books
    get 'show_libraries', on: :collection, as: :show_libraries
    get 'show_librarians', on: :collection, as: :show_librarians
    get 'show_students', on: :collection, as: :show_students
    get 'search_book', on: :collection, as: :search_book
  end

  resources :librarians do
    get 'list_checkedoutBooksAndStudents', on: :collection, as: :list_checkedoutBooksAndStudents
    get 'list_checkedoutBooks', to: 'librarians#list_checkedoutBooks', on: :collection, as: :list_checkedoutBooks
    get 'getOverdueBooks', to: 'librarians#getOverdueBooks', on: :collection, as: :getOverdueBooks
    get 'librarian_special_book', to: 'librarians#librarian_special_book', on: :collection, as: :librarian_special_book
    get 'librarian_book_view/:library_id', to:  'librarians#librarian_book_view', on: :collection, as: :librarian_book_view
    get 'viewHoldRequest', to: 'librarians#viewHoldRequest', on: :collection, as: :viewHoldRequest
    get 'viewBookHistory', on: :collection, as: :viewBookHistory
    get 'reject_special_book', to: 'librarians#reject_special_book', on: :collection, as: :reject_special_book
    get 'approve_special_book', to: 'librarians#approve_special_book', on: :collection, as: :approve_special_book
    get 'search_book', to: 'librarians#search_book', on: :collection, as: :search_book
  end

  resources :students do
    get 'getStudentBookFine', to: 'students#getStudentBookFine', on: :collection, as: :getStudentBookFine
    get 'getBookmarkBooks', to: 'students#getBookmarkBooks', on: :collection, as: :getBookmarkBooks
    get 'bookmark', to: 'students#bookmark', on: :collection, as: :bookmark
    get 'unbookmark', to: 'students#unbookmark', on: :collection, as: :unbookmark
    get 'repealRequest', to: 'students#repealRequest', on: :collection, as: :repealRequest
    get 'returnBook', on: :collection, as: :returnBook
    get 'student_libraries_index',  on: :collection, as: :student_libraries_index #to: 'libraries#student_libraries_index', as: :student_libraries_index
    get 'books_students',  to: 'students#books_students', on: :collection, as: :books_students
    get 'checkout', to: 'students#checkout', on: :collection, as: :checkout
    get 'search_book', to: 'students#search_book', on: :collection, as: :search_book
  end

  resources :universities do
    resources :addresses, only: [:show]
    resources :telephones, only: [:show, :destroy]
  end

  root  'home_page#index'

  get '/requestBook' => 'books#requestBook', :as => 'requestBook'

  get '/restricted' => 'librarians#restricted', :as => 'restricted'

  get '/add_books' => 'books#new', :as => 'add_books'
  get '/add_students' => 'students#new', :as => 'add_students'
  get '/add_librarians' => 'librarians#new', :as => 'add_librarians'

  # Capturar erros de rota não correspondidos
  match '*unmatched_route', to: 'errors#handle_routing_error', via: :all

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unprocessable_entity'
  get '/500', to: 'errors#internal_server_error'

end
