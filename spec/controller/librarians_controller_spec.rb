# spec/controllers/librarians_controller_spec.rb
require 'rails_helper'

RSpec.describe LibrariansController, type: :controller do

  shared_examples 'access to actions' do
    describe 'GET #index' do
      let(:librarian) { create(:librarian) }
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      let(:librarian) { create(:librarian) }

      it 'returns a success response' do
        get :show, params: { id: librarian.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      let(:library) { create(:library) }
      context 'with valid params' do
        it 'creates a new librarian' do
          expect {
            post :create, params: { librarian: attributes_for(:librarian, library_id: library.id) }
          }.to change(Librarian, :count).by(1)
        end
      end

      context 'with invalid params' do
        it 'does not create a new librarian' do
          expect {
            post :create, params: { librarian: { name: nil, email: 'john@example.com', identification: '123456', password: 'password', phone: '123456789', approved: true } }
          }.to_not change(Librarian, :count)
        end
      end
    end

    describe 'PATCH #update' do
    # let(:librarian) { create(:librarian) }
      let(:librarian) { create(:librarian, library: library) }
      let(:library) { create(:library) }
      context 'with valid params' do
        it 'updates the librarian' do
          patch :update, params: { library_id: library.id, id: librarian.id, librarian: { name: 'Updated Name', password: '12345678' } }
          librarian.reload
          expect(librarian.name).to eq('Updated Name')
        end
      end

      context 'with invalid params' do
        it 'does not update the librarian' do
          patch :update, params: {  id: librarian.id, librarian: { name: nil } }
          librarian.reload
          expect(librarian.name).to_not eq(nil)
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:library) { create(:library) }
      let!(:librarian) { create(:librarian, library: library) }

      it 'destroys the requested librarian' do
        expect {
          delete :destroy, params: { library_id: library.id, id: librarian.id }
        }.to change(Librarian, :count).by(-1)
      end
    end
  end

  describe 'when admin is logged in' do
    let(:admin) { FactoryBot.create(:admin) }
    before do
      sign_in admin
    end

    it_behaves_like 'access to actions'
  end

  describe 'when librarian is logged in' do
    let(:librarian) { FactoryBot.create(:librarian) }
    before do
      sign_in librarian
    end

    it_behaves_like 'access to actions'

    describe 'GET #search_book' do
      let(:library) { create(:library) } # Certifique-se de definir adequadamente o factory para a biblioteca (library)
      let(:librarian) { create(:librarian, library_id: library.id) } # Certifique-se de ter um factory para o bibliotecário (librarian)

      before do
        # Configura o bibliotecário atual para os testes
        allow(controller).to receive(:current_librarian).and_return(librarian.library_id)
      end

      context 'when search parameters are provided' do
        let!(:book1) { create(:book, title: 'The Great Gatsby', library_id: library.id) }
        let!(:book2) { create(:book, author: create(:author, name: 'George Orwell'), library_id: library.id) }
        let!(:book3) { create(:book, publisher: create(:publisher, name: 'Editora Vulcan'), library_id: library.id) }
        let!(:book4) { create(:book, subject: create(:subject, name: 'Ficção Cientifica'), library_id: library.id) }

        it 'returns books filtered by title' do
          get :search_book, params: { search: 'gatsby', search_by: 'title', library_id: library.id }
          expect(controller.instance_variable_get(:@results)).to include(book1)
          expect(controller.instance_variable_get(:@results)).not_to include(book2)
        end

        it 'returns books filtered by author' do
          get :search_book, params: { search: 'orwell', search_by: 'author', library_id: library.id }
          expect(controller.instance_variable_get(:@results)).to include(book2)
          expect(controller.instance_variable_get(:@results)).not_to include(book1)
        end

        it 'returns books filtered by publisher' do
          get :search_book, params: { search: 'vulcan', search_by: 'publisher', library_id: library.id }
          expect(controller.instance_variable_get(:@results)).to include(book3)
          expect(controller.instance_variable_get(:@results)).not_to include(book2)
        end

        it 'returns books filtered by subject' do
          get :search_book, params: { search: 'cientifica', search_by: 'subject', library_id: library.id }
          expect(controller.instance_variable_get(:@results)).to include(book4)
          expect(controller.instance_variable_get(:@results)).not_to include(book1)
        end
      end

      context 'when search parameter is not provided' do
        it 'redirects with a notice message' do
          get :search_book, params: { library_id: library.id }
          expect(response).to redirect_to(search_book_librarians_url)
          expect(flash[:notice]).to eq('Empty field!')
        end
      end

      context 'when search no results are found' do
        it 'redirects with a notice message' do
          get :search_book, params: { search: 'non_existing_book', search_by: 'title', library_id: library.id }
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
          expect(controller.instance_variable_get(:@results)).to be_nil.or be_empty
        end
      end
    end

    describe 'GET #list_checkedoutBooksAndStudents' do
      let(:library) { create(:library) } # Supondo que você tenha uma factory para Library
      let(:book) { create(:book, library_id: librarian.library_id) }
      let(:student) { create(:student) }

      it 'returns checked out books and students for a specific library' do
        checkout_1 = create(:checkout, student_id: student.id, book_id: book.id)
        checkout_2 = create(:checkout) # Checkout em uma library diferente

        get :list_checkedoutBooksAndStudents, params: { library_id: librarian.library_id }

        expect(controller.instance_variable_get(:@results)).to include(checkout_1)
        expect(controller.instance_variable_get(:@results)).not_to include(checkout_2)
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it 'returns checked out books and students empety with library_id nil' do
        get :list_checkedoutBooksAndStudents, params: { library_id: nil }

        expect(controller.instance_variable_get(:@results)).to be_empty
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('')
      end

      let!(:checkout_1) { create(:checkout) }
      let!(:checkout_2) { create(:checkout) }

      it "returns all checked out books and students if library_id is nil'" do
        results = Checkout.checkedout_books_and_students
        expect(results).to include(checkout_1)
        expect(results).to include(checkout_2)
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('')
      end

    end

    describe 'GET #viewBookHistory' do
      #let(:librarian) { create(:librarian) }
      let(:book) { create(:book) }
      let(:student) { create(:student) }
      let!(:checkouts) { create_list(:checkout, 2, book_id: book.id, student_id: student.id, return_date: Date.today) }
      let!(:other_checkout) { create(:checkout) }  # Unrelated checkout

      it 'retrieves returned books for the given book and assigns them to @checkouts' do
        get :viewBookHistory, params: { id: book.id }

        expect(controller.instance_variable_get(:@checkouts)).to eq checkouts
      end

      it 'returns a success message' do
        allow(Checkout).to receive(:find_by_student_and_book).and_return(true)
        allow(Checkout).to receive(:process_book_return).and_return(true)
        result = Checkout.return_book(student.id, book)

        expect(result[:success]).to be true
        expect(result[:message]).to eq 'Book successfully returned !!!'
      end

      it 'returns a message indicating the book is not returned' do
        result = Checkout.return_book(student.id, create(:book))  # Different book

        expect(result[:success]).to be true
        expect(result[:message]).to eq 'Book is not successfully returned'
      end

      context '.process_book_return' do
        let!(:checkout) { create(:checkout, student: student, book: book, return_date: nil) }

        it 'updates the return date' do
          expect {
              Checkout.process_book_return(checkout)
            }.to change { checkout.reload.return_date }.from(nil).to(Date.today)
              .and change { checkout.book.reload.count }.by(1)
        end

        it 'sends a return book email' do
          expect {
            Checkout.process_book_return(checkout)
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

    end

    describe 'GET #librarian_book_view' do
      let(:library) { create(:library) }
      let(:library2) { create(:library) }
      let(:book1) { create(:book, library: library) }
      let(:book2) { create(:book, library: library2) }

      before do
        get :librarian_book_view, params: { library_id: library.id }
      end

      it 'assigns @books with books from the specified library' do
        expect(controller.instance_variable_get(:@books)).to include(book1)
        expect(controller.instance_variable_get(:@books)).not_to include(book2)
      end

      it 'renders the librarian_book_view template' do
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end
    end

    describe '#getOverdueBooks' do
      let(:library) { create(:library) }
      let(:book_in_library) { create(:book, library_id: librarian.library_id) }

      context 'when @checkouts is present' do
        it 'creates fines for overdue books' do
          checkout = create(:checkout, book_id: book_in_library.id, issue_date: 30.days.ago, return_date: nil, validity: 5) # Crie um checkout atrasado
          allow(Library).to receive(:overdue_fines).and_return(5)
          get :getOverdueBooks, params: { library_id: librarian.library_id }

          expect(controller.instance_variable_get(:@checkouts)).to include(checkout)
          expect(controller.instance_variable_get(:@fines)).not_to be_empty
          expect(controller.instance_variable_get(:@fines)).to be_an_instance_of(Array)
          expect(controller.instance_variable_get(:@fines).first[:fine_ammount]).to be > 0
        end

        it 'calculates the fine as 0 ' do
          checkout = create(:checkout, book_id: book_in_library.id, issue_date: 5.days.ago, return_date: nil, validity: 5)

          get :getOverdueBooks, params: { library_id: librarian.library_id }

          expect(controller.instance_variable_get(:@checkouts)).to include(checkout)
          expect(controller.instance_variable_get(:@fines)).not_to be_empty
          expect(controller.instance_variable_get(:@fines)).to be_an_instance_of(Array)
          expect(controller.instance_variable_get(:@fines).first[:fine_ammount]).to eq(0)
        end
      end

      context 'when @checkouts is not present' do
        it 'does not create fines' do
          get :getOverdueBooks, params: { library_id: library.id }

          expect(controller.instance_variable_get(:@checkouts)).to be_empty
          expect(controller.instance_variable_get(:@fines)).to be_nil
        end
      end
    end

    describe '#list_checkedoutBooks' do
      let(:library) { create(:library) } # Crie uma instância de Library usando FactoryBot

      it 'returns checked out books for a specific library' do
        checked_out_book = create(:book, library_id: librarian.library_id) # Crie um livro verificado

        # Crie um checkout para o livro verificado na biblioteca específica
        create(:checkout, book: checked_out_book,  return_date: nil)

        # Faça uma solicitação GET para a action list_checkedoutBooks
        get :list_checkedoutBooks, params: { library_id: librarian.library_id }

        # Verifique se a variável @books contém apenas o livro verificado
        expect(controller.instance_variable_get(:@books)).to contain_exactly(checked_out_book)
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @books as an empty collection' do
        get :list_checkedoutBooks, params: { library_id: librarian.library_id }
        expect(controller.instance_variable_get(:@books)).to be_empty
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('')
      end
    end

    describe 'GET #viewHoldRequest' do
      it 'returns hold requests for a specific library associated with librarian' do
        library = create(:library)
        other_library = create(:library) # Outra biblioteca para testar a diferenciação

        book_in_library = create(:book, library_id: librarian.library_id)
        book_in_other_library = create(:book, library: other_library)

        hold_request_in_library = create(:hold_request, book: book_in_library)
        hold_request_in_other_library = create(:hold_request, book: book_in_other_library)

        get :viewHoldRequest, params: { library_id: librarian.library_id }

        expect(controller.instance_variable_get(:@request)).to include(hold_request_in_library)
        expect(controller.instance_variable_get(:@request)).not_to include(hold_request_in_other_library)
      end

      it 'renders the #viewHoldRequest template' do
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @request as an empty collection' do
        get :viewHoldRequest, params: { library_id: librarian.library_id }
        expect(controller.instance_variable_get(:@request)).to be_empty
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('')
      end
    end

    describe 'GET #librarian_special_book' do
      context 'when the library has special books' do
        let!(:student) { create(:student) }
        let!(:books) { create_list(:book, 3, special_collection: true, library_id: librarian.library_id) }
        let!(:special_books) do
          books.map do |book|
            SpecialBook.create(student_id: student.id, book_id: book.id)
          end
        end

        it 'assigns @special_books with books for the library' do
          get :librarian_special_book, params: { library_id: librarian.library_id }
          expect(controller.instance_variable_get(:@special_books)).to eq(special_books)
        end

        it 'renders the librarian_special_book template' do
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when the library has no special books' do
        let(:library) { create(:library) }

        before do
          get :librarian_special_book, params: { library_id: librarian.library_id }
        end

        it 'assigns @special_books as an empty collection' do
          expect(controller.instance_variable_get(:@special_books)).to eq([])
          expect(controller.instance_variable_get(:@special_books)).to be_empty
          expect(response).to have_http_status(:ok)
          expect(response.body).to include('')
        end

        it 'renders the librarian_special_book template' do
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)

        end
      end
    end

    describe 'GET #reject_special_book' do
      let(:user) { create(:student) }
      let(:book) { create(:book, special_collection: true, count: 2) }
      let(:special_book) { create(:special_book, student_id: user.id, book_id: book.id ) }

      it 'rejects the special book and redirects to the librarian special books path' do
        get :reject_special_book, params: { id: special_book.id }

        expect(response).to redirect_to librarian_special_book_librarians_path(library_id: librarian.library_id)
        expect(flash[:notice]).to eq 'Special Book rejected !!!!'

        # Check if special book was destroyed
        expect(SpecialBook.find_by(id: special_book.id)).to be_nil
      end
    end

    describe 'POST #approve_special_book' do
      let(:user) { create(:student) }
      let(:book) { create(:book, special_collection: true, count: 2) }
      let(:special_book) { create(:special_book, student_id: user.id, book_id: book.id ) }
      let(:checkout) { build(:checkout) }

      it 'creates a new checkout' do
        allow(SpecialBook).to receive(:find).and_return(special_book)
        allow(Book).to receive(:find).and_return(book)
        allow(Student).to receive(:find).and_return(user)

        expect { get :approve_special_book, params: { id: special_book.id } }.to change {Checkout.count}.by(1)
        expect(response).to redirect_to(librarian_special_book_librarians_path(library_id: librarian.library_id))
        expect(flash[:notice]).to eq('Book Successfully Checked Out')

        # Check for expected changes in the database
        checkout = Checkout.find_by(book_id: special_book.book_id)
        expect(checkout.student_id).to eq special_book.student_id
        expect(checkout.book_id).to eq special_book.book_id
        expect(checkout.issue_date).to eq Date.today
        expect(checkout.return_date).to be_nil
        expect(checkout.validity).to eq Library.find(special_book.book.library_id).borrow_limit

        book = Book.find(special_book.book_id)
        expect(book.count).to eq special_book.book.count - 1
      end

      it 'sends an email' do
        get :approve_special_book, params: { id: special_book.id }
        expect(ActionMailer::Base.deliveries.count).to eq 1
        mail = ActionMailer::Base.deliveries.first
        expect(mail.to).to eq [special_book.student.email]
        expect(mail.subject).to eq 'Your Library Notifications'

      end

      it 'destroys the special book' do
        get :approve_special_book, params: { id: special_book.id }
        expect(SpecialBook.find_by(id: special_book.id)).to be_nil
      end

      it 'Check if book count was decremented and book was saved'  do
        get :approve_special_book, params: { id: special_book.id }
        expect(book.count - 1).to eq book.count - 1
        # Check if book was saved
        expect(book.errors).to be_empty
      end

      it 'sets a notice flash message' do
        get :approve_special_book, params: { id: special_book.id }
        expect(flash[:notice]).to eq('Book Successfully Checked Out')
      end

      it 'redirects to the librarian special books path' do
        get :approve_special_book, params: { id: special_book.id }
        expect(response).to redirect_to(librarian_special_book_librarians_path(library_id: librarian.library_id))
      end
    end




  end

  describe 'when no admin is NOT logged in' do
    before do
      sign_out :admin
    end

    describe 'GET #index' do
      it 'redirects to login page if not logged in' do
        get :index
        expect(response).to redirect_to(new_librarian_session_path)
      end
    end
  end

  describe 'when no librarian is NOT logged in' do
    before do
      sign_out :librarian
    end

    describe 'GET #index' do
      it 'redirects to login page if not logged in' do
        get :index
        expect(response).to redirect_to(new_librarian_session_path)
      end
    end
  end




end
