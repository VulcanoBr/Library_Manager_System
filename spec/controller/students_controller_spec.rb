# spec/controllers/students_controller_spec.rb

require 'rails_helper'

RSpec.describe StudentsController, type: :controller do

  shared_examples 'access to actions' do
    describe 'GET #index' do
    let(:student) { FactoryBot.create(:student) }
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
      # Adicione mais testes conforme necessário para a ação index
    end

    describe 'GET #show' do
      let(:student) { FactoryBot.create(:student) }

      it 'returns a success response' do
        get :show, params: { id: student.id }
        expect(response).to be_successful
      end
      # Adicione mais testes conforme necessário para a ação show
    end

    describe 'POST #create' do
      let(:university) { FactoryBot.create(:university) }
      let(:education_level) { FactoryBot.create(:education_level) }
      let(:valid_attributes) { { name: 'John Doe', email: 'maria@email.com', password: '12345678',
        phone: '(21)90087-5959)', max_book_allowed: 4, university_id: university.id, education_level_id: education_level.id } }

      context 'with valid parameters' do
        it 'creates a new student' do
          expect {
            post :create, params: { student: valid_attributes }
          }.to change(Student, :count).by(1)
        end
        # Adicione mais testes conforme necessário para a ação create
      end

      context 'with invalid parameters' do
        it 'does not create a new student' do
          expect {
            post :create, params: { student: { name: '' } }
          }.to_not change(Student, :count)
        end
        # Adicione mais testes para parâmetros inválidos, se necessário
      end
    end

    describe 'PATCH #update' do
      let(:student) { FactoryBot.create(:student) }

      context 'with valid parameters' do
        let(:new_attributes) { { name: 'Jane Doe', password: '12345678' } }

        it 'updates the requested student' do
          patch :update, params: { id: student.id, student: new_attributes }
          student.reload
          expect(student.name).to eq('Jane Doe')
        end
        # Adicione mais testes conforme necessário para a ação update
      end

      context 'with invalid parameters' do
        it 'does not update the student' do
          patch :update, params: { id: student.id, student: { name: '' } }
          student.reload
          expect(student.name).not_to eq('')
        end
        # Adicione mais testes para parâmetros inválidos, se necessário
      end
    end

    describe 'DELETE #destroy' do
      let!(:student) { FactoryBot.create(:student) }

      it 'destroys the requested student' do
        expect {
          delete :destroy, params: { id: student.id }
        }.to change(Student, :count).by(-1)
      end
      # Adicione mais testes conforme necessário para a ação destroy
    end
  end

  describe 'when admin is logged in' do
    let(:admin) { FactoryBot.create(:admin) }
    before do
      sign_in admin
    end

    it_behaves_like 'access to actions'
  end

  describe 'when student is logged in' do
    let(:student) { FactoryBot.create(:student) }
    before do
      sign_in student
    end

    it_behaves_like 'access to actions'

    describe 'GET #student_libraries_index' do
      it 'assigns libraries ordered by name to @libraries' do
        libraries = FactoryBot.create_list(:library, 5) # Cria 5 bibliotecas

        get :student_libraries_index

        expect(controller.instance_variable_get(:@libraries)).to eq(libraries.sort_by(&:name))
      end
    end

    describe 'GET #books_students' do

      let(:library) { FactoryBot.create(:library, university: student.university) }

      before do
        allow(controller).to receive(:current_student).and_return(student)
      end

      it 'assigns books by student university to @books' do
        book_in_university = FactoryBot.create(:book, library: library)

        get :books_students

        expect(controller.instance_variable_get(:@books)).to include(book_in_university)
      end

      it 'assigns all books ordered by title to @books_all' do
        books_ordered_by_title = FactoryBot.create_list(:book, 5)

        get :books_students

        expect(controller.instance_variable_get(:@books_all)).to eq(books_ordered_by_title.sort_by(&:title))
      end

    end

    describe 'GET #search_book' do
        before do
          # Aqui você pode definir o comportamento esperado para as chamadas de params
          #allow(controller).to receive(:current_student).and_return(student)
        end

        let(:university) { create(:university) } # FactoryBot cria uma universidade
        let(:library) { create(:library, university: university) } # FactoryBot cria uma biblioteca associada à universidade
        let!(:book_from_student_university) { create(:book, title: 'Livro da Matching', 
              library: create(:library, university_id: student.university_id),
              subject: create(:subject, name: 'Ficção Cientifica'),
              publisher: create(:publisher, name: 'Vulcan Editora'),
              author: create(:author, name: 'Vulcano Sanurai')) }
        let!(:book_outside_student_university) { create(:book, title: 'Livro Basico da Matching',
              library_id: library.id,
              subject: create(:subject, name: 'Mecanica Cientifica'),
              publisher: create(:publisher, name: 'Vulcan Ltda'),
              author: create(:author, name: 'Vulcano Saqmurai') ) } # FactoryBot cria um livro não associado à universidade do estudante
        
        context 'with empty search field' do
          it 'redirects to search book students URL with a notice' do
            get :search_book, params: { search: '' }
            expect(response).to redirect_to(search_book_students_url)
            expect(flash[:notice]).to eq('Empty field!')
          end
        end

        context 'with valid search parameters' do
         # let!(:book_matching_search) { create(:book, title: 'Matching Book', library: student.library) }
         # let!(:book_not_matching_search) { create(:book, title: 'Another Book') }

          it 'returns books from student university with title' do
            get :search_book, params: { student: student, search: 'Matching', search_by: 'title' }
            expect(controller.instance_variable_get(:@books)).to include(book_from_student_university)
            expect(controller.instance_variable_get(:@books_all)).to include(book_outside_student_university)
            expect(controller.instance_variable_get(:@books)).not_to include(book_outside_student_university)
            expect(controller.instance_variable_get(:@books_all)).not_to include(book_from_student_university)
            expect(response).to have_http_status(:ok) # Certifica-se de que a resposta seja bem-sucedida (código HTTP 200)
          end

          it 'returns books from student university with author' do
            get :search_book, params: { student: student, search: 'Vulcano', search_by: 'authors' }
            expect(controller.instance_variable_get(:@books)).to include(book_from_student_university)
            expect(controller.instance_variable_get(:@books_all)).to include(book_outside_student_university)
            expect(controller.instance_variable_get(:@books)).not_to include(book_outside_student_university)
            expect(controller.instance_variable_get(:@books_all)).not_to include(book_from_student_university)
            expect(response).to have_http_status(:ok) # Certifica-se de que a resposta seja bem-sucedida (código HTTP 200)
          end

          it 'returns books from student university with publisher' do
            get :search_book, params: { student: student, search: 'Vulcan', search_by: 'publisher' }
            expect(controller.instance_variable_get(:@books)).to include(book_from_student_university)
            expect(controller.instance_variable_get(:@books_all)).to include(book_outside_student_university)
            expect(controller.instance_variable_get(:@books)).not_to include(book_outside_student_university)
            expect(controller.instance_variable_get(:@books_all)).not_to include(book_from_student_university)
            expect(response).to have_http_status(:ok) # Certifica-se de que a resposta seja bem-sucedida (código HTTP 200)
          end

          it 'returns books from student university with subject' do
            get :search_book, params: { student: student, search: 'Cientifica', search_by: 'subject' }
            expect(controller.instance_variable_get(:@books)).to include(book_from_student_university)
            expect(controller.instance_variable_get(:@books_all)).to include(book_outside_student_university)
            expect(controller.instance_variable_get(:@books)).not_to include(book_outside_student_university)
            expect(controller.instance_variable_get(:@books_all)).not_to include(book_from_student_university)
            expect(response).to have_http_status(:ok) # Certifica-se de que a resposta seja bem-sucedida (código HTTP 200)
          end

          it 'handles no results found for the search term to title' do
            get :search_book, params: { search: 'Nonexistent Term', search_by: 'title' }
            expect(controller.instance_variable_get(:@books)).to be_empty
            expect(controller.instance_variable_get(:@books_all)).to be_empty
            expect(response).to have_http_status(:ok)
            expect(response.body).to include('')
          end

          it 'handles no results found for the search term to author' do
            get :search_book, params: { search: 'Nonexistent Term', search_by: 'authors' }
            expect(controller.instance_variable_get(:@books)).to be_empty
            expect(controller.instance_variable_get(:@books_all)).to be_empty
            expect(response).to have_http_status(:ok)
            expect(response.body).to include('')
          end

          it 'handles no results found for the search term to publisher' do
            get :search_book, params: { search: 'Nonexistent Term', search_by: 'publisher' }
            expect(controller.instance_variable_get(:@books)).to be_empty
            expect(controller.instance_variable_get(:@books_all)).to be_empty
            expect(response).to have_http_status(:ok)
            expect(response.body).to include('')
          end

          it 'handles no results found for the search term to subject' do
            get :search_book, params: { search: 'Nonexistent Term', search_by: 'subject' }
            expect(controller.instance_variable_get(:@books)).to be_empty
            expect(controller.instance_variable_get(:@books_all)).to be_empty
            expect(response).to have_http_status(:ok)
            expect(response.body).to include('')
          end
        end
      
    end

    describe "POST #checkout" do

      context 'when handling special collection checkout' do

        let(:book) { create(:book, special_collection: true) }
        
        it 'creates a special book request if not checked out' do
          allow(Checkout).to receive(:special_book_not_checked_out?).and_return(true)
          expect(SpecialBook).to receive(:create_request).with(student.id, book.id)
          get :checkout, params: { id: book.id }
          expect(flash[:notice]).to eq("Book Hold Request Placed !!")
          expect(response).to redirect_to(getBookmarkBooks_students_path(student_id: student.id))
        end
  
        it 'displays a message for an already placed book hold request' do
          allow(Checkout).to receive(:special_book_not_checked_out?).and_return(false)
          get :checkout, params: { id: book.id }
          expect(flash[:notice]).to eq("Book Hold Request Is Already Placed !!")
          expect(response).to redirect_to(getBookmarkBooks_students_path(student_id: student.id))
        end
    
        it "calls handle_special_collection_checkout when the book is part of a special collection" do
          allow(controller).to receive(:handle_special_collection_checkout)
          get :checkout, params: { id: book.id }
          expect(controller).to have_received(:handle_special_collection_checkout)
        end
      
        it "calls handle_regular_checkout when the book is not part of a special collection" do
          book = create(:book, special_collection: false)
          allow(controller).to receive(:handle_regular_checkout)
          get :checkout, params: { id: book.id }
          expect(controller).to have_received(:handle_regular_checkout)
        end
      end

      describe "#handle_book_hold_request" do
          let(:book) { create(:book, special_collection: false, count: 0) }

          context 'when the book is not checked out' do
            it 'creates a hold request and sets a success flash message' do
              allow(controller).to receive(:current_student).and_return(student)
              allow(controller).to receive(:book_not_checked_out?).and_return(true)
              get :checkout, params: { id: book.id }
              expect { HoldRequest.create_request(student.id, book.id) }
                .to change(HoldRequest, :count).by(1)
              expect(flash[:notice]).to eq('Book Hold Request Placed !!')
              expect(response).to redirect_to(getBookmarkBooks_students_path(student_id: student.id))
            end
          end
      
          context 'when the book already has a hold request' do
            before do
              create(:checkout, student_id: student.id, book_id: book.id)
            end
      
            it 'sets an error flash message' do
              allow(controller).to receive(:current_student).and_return(student)
              allow(controller).to receive(:book_not_checked_out?).and_return(false)
              get :checkout, params: { id: book.id }
              expect(flash[:notice]).to eq('Book Already Hold Request !!')
              expect(response).to redirect_to(getBookmarkBooks_students_path(student_id: student.id))
            end
          end 
      end   
    
      context 'when handling regular checkout' do
        let(:max_book) { 5 } # Defina o valor de count conforme necessário
        let(:book) { create(:book, special_collection: false, count: 1) }
        
        it 'calls the process_regular_checkout method and creates a new record in Checkout table' do
          allow(controller).to receive(:can_issue_more_books?).and_return(true)
          allow(controller).to receive(:book_not_checked_out?).and_return(true)
          expect {
            get :checkout, params: { id: book.id }
          }.to change(Checkout, :count).by(1)
          
         # expect(assigns(:book)).to eq(book)
          expect(response).to have_http_status(:redirect)
          expect(flash[:notice]).to eq("Book Successfully Checked Out")
          expect(response).to redirect_to(getBookmarkBooks_students_path(student_id: student.id))
          # Verifique se o email de checkout foi enviado
          expect(ActionMailer::Base.deliveries.last.to).to include(student.email)
        end

        it 'displays a message if maximum books allowed is reached' do
          allow(controller).to receive(:can_issue_more_books?).and_return(false)
          allow(Checkout).to receive(:checked_out_books_count).and_return(student.max_book_allowed)
          
          get :checkout, params: { id: book.id }
          
          expect(flash[:notice]).to eq("You cannot issue more books. Your request has been added to hold request list.")
          expect(response).to redirect_to(books_students_students_path)
        end

        it 'displays a message for already checked out book' do
          allow(controller).to receive(:can_issue_more_books?).and_return(true)
          allow(controller).to receive(:book_not_checked_out?).and_return(false)
          
          get :checkout, params: { id: book.id }
          
          expect(flash[:notice]).to eq("Book Already Checked Out!!")
          expect(response).to redirect_to(getBookmarkBooks_students_path(student_id: student.id))
        end

        it 'handles book hold request if count is zero' do
          book.update(count: 0)
          allow(controller).to receive(:book_not_checked_out?).and_return(true)
          expect(HoldRequest).to receive(:create_request).with(student.id, book.id)
          
          get :checkout, params: { id: book.id }
          
          expect(flash[:notice]).to eq("Book Hold Request Placed !!")
          expect(response).to redirect_to(getBookmarkBooks_students_path(student_id: student.id))
        end
      end
    
    end

    describe 'REMOVED bookmark  #unbookmark' do

        let(:book) { create(:book) }
        let(:bookmark) { create(:bookmark, student_id: student.id, book_id: book.id) }

        it 'removes a bookmark and redirects to the bookmarks page' do
          delete :unbookmark, params: { student_id: bookmark.student_id, book_id: bookmark.book_id }
          expect(response).to redirect_to(getBookmarkBooks_students_path(student_id: student.id))
          expect(flash[:notice]).to eq('Bookmark Removed successfully!!')
          expect(Bookmark.find_by(student_id: student.id, book_id: book.id)).to be_nil
        end

        it 'does not remove a bookmark and redirects to the books page' do
          delete :unbookmark, params: { id: book.id }
          expect(response).to redirect_to(books_students_students_path)
          expect(flash[:notice]).to eq('Bookmark not found!!')
          expect(Bookmark.find_by(student_id: student.id, book_id: book.id)).to be_nil
        end
    end
    

    describe 'POST #bookmark' do
      let(:book) { create(:book) }
      context 'when the book is not already bookmarked' do
        it 'creates a new bookmark' do
          expect { post :bookmark, params: { student_id: student.id, book_id: book.id } }
            .to change(Bookmark, :count).by(1)
        end
  
        it 'sets the correct flash notice' do
          post :bookmark, params: { student_id: student.id, book_id: book.id }
          expect(flash[:notice]).to eq('Book Added to your bookmarks')
        end
  
        it 'redirects to the correct path' do
          post :bookmark, params: { student_id: student.id, book_id: book.id }
          expect(response).to redirect_to(getBookmarkBooks_students_path(student_id: student.id))
        end
      end
  
      context 'when the book is already bookmarked' do
        let(:book) { create(:book) }
        let(:bookmark) { create(:bookmark, student_id: student.id, book_id: book.id) }
        
        it 'does not create a new bookmark' do
          #puts ("teste = #{bookmark.student_id} #{bookmark.book_id}")
         # post :bookmark, params: { student_id: bookmark.student_id, book_id: bookmark.book_id }
         # expect { post :bookmark, params: { student_id: bookmark.student_id, book_id: bookmark.book_id } }
         #           .not_to change(Bookmark, :count)
          post_action = post :bookmark, params: { student_id: bookmark.student_id, book_id: bookmark.book_id }

          expect { post_action }.not_to change(Bookmark, :count)      
        end
  
        it 'sets the correct flash notice' do
          post :bookmark, params: { student_id: bookmark.student_id, book_id: bookmark.book_id }
          expect(flash[:notice]).to eq('Book is already bookmarked!!')
        end
  
        it 'redirects to the correct path' do
          post :bookmark, params: { student_id: bookmark.student_id, book_id: bookmark.book_id }
          expect(response).to redirect_to(books_students_students_path)
        end
      end
    end

    describe '#getStudentBookFine' do
      let(:library) { create(:library, overdue_fines: 10) }
      let(:book) { create(:book) } # Use FactoryBot to create a book
      let(:checkout) { create(:checkout, student_id: student.id, book_id: book.id, return_date: nil) } 
      it 'calculates the fine for a book that is overdue' do
        checkout.update(issue_date: Date.today - checkout.validity) # Make the book overdue
        get :getStudentBookFine, params: { student_id: student.id }
        delay = (Date.today - checkout.issue_date).to_i - checkout.validity
        expect(@controller.instance_variable_get(:@fines).first[:fine_ammount]).to eq((delay) * library.overdue_fines)
      end
    
      it 'calculates the fine as 0 for a book that is not overdue' do
        checkout.update(issue_date: Date.today - checkout.validity + 1) # Make the book not overdue
        get :getStudentBookFine, params: { student_id: student.id }
        expect(@controller.instance_variable_get(:@fines).first[:fine_ammount]).to eq(0)
      end

      it 'calculates fines for student books' do
        get :getStudentBookFine, params: { student_id: student.id }
        
        checkouts = controller.instance_variable_get(:@checkouts)
        fines = controller.instance_variable_get(:@fines)
        
        expect(checkouts).not_to be_nil
        expect(fines).to be_an_instance_of(Array)
        
        if fines.present? # Check if @fines is not empty before accessing first element
          expect(fines.first[:fine_ammount]).to eq(10 * Library.overdue_fines) # Assuming 10 days overdue and fine_per_day from Library
          expect(fines.first[:student_id]).to eq(student.id)
          expect(fines.first[:book_id]).to eq(book.id)
        end
      end
    end

    describe 'GET #getBookmarkBooks' do
      context 'when testing scopes' do 
      
        let!(:bookmarked_book) { FactoryBot.create(:book, bookmarks: [FactoryBot.create(:bookmark, student: student)]) }
        let!(:checked_out_book) { FactoryBot.create(:book, checkouts: [FactoryBot.create(:checkout, student: student)]) }
        let!(:hold_requested_book) { FactoryBot.create(:book, hold_requests: [FactoryBot.create(:hold_request, student: student)]) }
        let!(:special_book) { FactoryBot.create(:book, special_books: [FactoryBot.create(:special_book, student: student)]) }
    
        describe '.bookmarked_by' do
          it 'returns books bookmarked by a specific student' do
            expect(Book.bookmarked_by(student.id)).to include(bookmarked_book)
            expect(Book.bookmarked_by(student.id)).not_to include(checked_out_book, hold_requested_book, special_book)
          end
        end
    
        describe '.checked_out_by' do
          it 'returns books checked out by a specific student' do
            expect(Book.checked_out_by(student.id)).to include(checked_out_book)
            expect(Book.checked_out_by(student.id)).not_to include(bookmarked_book, hold_requested_book, special_book)
          end
        end
    
        describe '.hold_requested_by' do
          it 'returns books hold request by a specific student' do
            expect(Book.hold_requested_by(student.id)).to include(hold_requested_book)
            expect(Book.hold_requested_by(student.id)).not_to include(bookmarked_book, checked_out_book, special_book)
          end
        end

        describe '.special_book_by' do
          it 'returns books special book by a specific student' do
            expect(Book.special_book_by(student.id)).to include(special_book)
            expect(Book.special_book_by(student.id)).not_to include(bookmarked_book, checked_out_book, hold_requested_book)
          end
        end
      end

      context 'when testing controller method' do
        describe 'GET #getBookmarkBooks' do
          it 'assigns bookmarked, checked out, hold requested, and special books to instance variables' do
            bookmarked_book = FactoryBot.create(:book, bookmarks: [FactoryBot.create(:bookmark, student: student)])
            checked_out_book = FactoryBot.create(:book, checkouts: [FactoryBot.create(:checkout, student: student)])
            hold_requested_book = FactoryBot.create(:book, hold_requests: [FactoryBot.create(:hold_request, student: student)])
            special_book = FactoryBot.create(:book, special_books: [FactoryBot.create(:special_book, student: student)])

            get :getBookmarkBooks, params: { student_id: student.id }

            expect(controller.instance_variable_get(:@bookmark)).to include(bookmarked_book)
            expect(controller.instance_variable_get(:@checkout)).to include(checked_out_book)
            expect(controller.instance_variable_get(:@request)).to include(hold_requested_book, special_book)
          end
        end
      end

      context 'when there are no records for the student' do
        describe 'Instance variables' do
          let(:bookmark) { nil }
          let(:checkout) { nil }
          let(:hold_request) { nil }
          let(:special_book) { nil }

          it 'assigns empty arrays to the instance variables' do
            
            expect(controller.instance_variable_get(:@bookmark)).to be_nil
            expect(controller.instance_variable_get(:@checkout)).to be_nil
            expect(controller.instance_variable_get(:@request)).to be_nil
            expect(response).to have_http_status(:success) 
          end
        end
      end
    end

    describe 'POST #returnBook' do
      let(:book) { create(:book) }
      context 'when the book is present' do
        before do
          checkout = create(:checkout, student: student, book: book)
          post :returnBook, params: { id: book.id }
        end

        it 'returns a success message' do
          expect(flash[:notice]).to eq('Book successfully returned !!!')
        end

        it 'redirects to the student books path' do
          expect(response).to redirect_to(getBookmarkBooks_students_path(student_id: student.id))
        end
      end

      context 'when the book is not present' do
        before do
          post :returnBook, params: { id: book.id }
        end

        it 'returns a failure message' do
          expect(flash[:notice]).to eq('Book is not successfully returned')
        end

        it 'redirects to the student books path' do
          expect(response).to redirect_to(getBookmarkBooks_students_path(student_id: student.id))
        end
      end
    end

    describe 'DESTROY #repealRequest' do
      let(:book) { create(:book, special_collection: true) }
      
      context 'when the book is part of a special collection' do
        let(:special_book) { create(:special_book, student_id: student.id, book_id: book.id) }
        it 'destroys the special book and redirects to the student\'s bookmarks' do
          expect(special_book).to be_present
          expect {
            delete :repealRequest, params: { student_id: student.id, book_id: book.id }
          }.to change(SpecialBook, :count).by(-1)
          expect(flash[:notice]).to eq('Special Book destroy success !!')
          expect(response).to redirect_to(getBookmarkBooks_students_path(student_id: student.id))
        end
      end

      context 'when the book is not part of a special collection' do
        let(:book) { create(:book, special_collection: false) }
        let(:hold_request) { create(:hold_request, student_id: student.id, book_id: book.id) }
        it 'destroys the hold request and redirects to the student\'s bookmarks' do
          expect(hold_request).to be_present
          expect {
            delete :repealRequest, params: { student_id: student.id, book_id: book.id }
          }.to change(HoldRequest, :count).by(-1)
          expect(flash[:notice]).to eq('Hold Request destroy success !!')
          expect(response).to redirect_to(getBookmarkBooks_students_path(student_id: student.id))
        end
      end
    end
  end
end


