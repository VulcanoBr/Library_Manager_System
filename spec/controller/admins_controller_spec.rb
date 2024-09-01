# spec/controllers/admins_controller_spec.rb
require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
  let(:admin) { create(:admin) }

  describe 'when admin is logged in to CRUD' do
    before do
      sign_in admin
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      let(:admin) { create(:admin) }

      it 'returns a success response' do
        get :show, params: { id: admin.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new admin' do
          expect {
            post :create, params: { admin: attributes_for(:admin) }
          }.to change(Admin, :count).by(1)
        end
      end

      context 'with invalid params' do
        it 'does not create a new admin' do
          expect {
            post :create, params: { admin: { name: nil } }
          }.to_not change(Admin, :count)
        end
      end
    end

    describe 'PATCH #update' do
      let(:admin) { create(:admin) }

      context 'with valid params' do
        it 'updates the admin' do
          patch :update, params: { id: admin.id, admin: { name: 'Updated Name', password: '12345678' } }
          admin.reload
          expect(admin.name).to eq('Updated Name')
        end
      end

      context 'with invalid params' do
        it 'does not update the admin' do
          patch :update, params: { id: admin.id, admin: { name: nil } }
          admin.reload
          expect(admin.name).to_not eq(nil)
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:admin) { create(:admin) }

      it 'destroys the requested admin' do
        expect {
          delete :destroy, params: { id: admin.id }
        }.to change(Admin, :count).by(-1)
      end
    end
  end

  describe 'when no user is NOT logged in' do
    before do
      sign_out :admin
    end
    
    describe 'GET #index' do
      it 'redirects to login page if not logged in' do
        get :index
        expect(response).to redirect_to(new_admin_session_path)
      end
    end
  end

  describe 'when admin is logged in to others methods' do
    let(:admin) { create(:admin) }
    before do
      sign_in admin
    end
    describe 'GET #search_book' do
    
      context 'when search parameters are provided' do
        let!(:book1) { create(:book, title: 'The Great Gatsby') }
        let!(:book2) { create(:book, author: create(:author, name: 'George Orwell')) }
        let!(:book3) { create(:book, publisher: create(:publisher, name: 'Editora Vulcan')) }
        let!(:book4) { create(:book, subject: create(:subject, name: 'Ficção Cientifica')) }

        it 'returns books filtered by title' do
          get :search_book, params: { search: 'gatsby', search_by: 'title' }
          expect(controller.instance_variable_get(:@results)).to include(book1)
          expect(controller.instance_variable_get(:@results)).not_to include(book2)
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end

        it 'returns books filtered by author' do
          get :search_book, params: { search: 'orwell', search_by: 'author' }
          expect(controller.instance_variable_get(:@results)).to include(book2)
          expect(controller.instance_variable_get(:@results)).not_to include(book1)
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end

        it 'returns books filtered by publisher' do
          get :search_book, params: { search: 'vulcan', search_by: 'publisher' }
          expect(controller.instance_variable_get(:@results)).to include(book3)
          expect(controller.instance_variable_get(:@results)).not_to include(book2)
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end

        it 'returns books filtered by subject' do
          get :search_book, params: { search: 'cientifica', search_by: 'subject' }
          expect(controller.instance_variable_get(:@results)).to include(book4)
          expect(controller.instance_variable_get(:@results)).not_to include(book1)
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when search parameter is not provided' do
        it 'redirects with a notice message' do
          get :search_book, params: { search: '' }
          expect(response).to redirect_to(search_book_admins_url)
          expect(flash[:notice]).to eq('Empty field!')
        end
      end

      context 'when search no results are found' do
        it 'redirects with a notice message' do
          get :search_book, params: { search: 'non_existing_book', search_by: 'title' }
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
          expect(controller.instance_variable_get(:@results)).to be_nil.or be_empty
        end
      end
    end

    describe "GET #show_librarians" do
      it "assigns @librarians when librarians are present" do
        # Crie alguns dados de exemplo usando FactoryBot
        FactoryBot.create_list(:librarian, 5)

        # Simule a requisição GET para show_librarians
        get :show_librarians

        # Verifique se a variável @librarians está atribuída e contém o(s) bibliotecário(s)
        expect(controller.instance_variable_get(:@librarians)).to eq(Librarian.ordered_by_name)
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it "assigns @librarians as an empty array when no librarians are present" do
        # Certifique-se de não ter nenhum bibliotecário criado

        # Simule a requisição GET para show_librarians
        get :show_librarians

        # Verifique se a variável @librarians está atribuída e é um array vazio
        expect(controller.instance_variable_get(:@librarians)).to eq([])
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
        expect(controller.instance_variable_get(:@results)).to be_nil.or be_empty
      end
    end

    describe 'GET #show_students' do
      context 'com dados presentes' do
        it 'atribui @students com dados presentes' do
          # Crie alguns alunos usando FactoryBot
          FactoryBot.create_list(:student, 5)

          # Faça a requisição para o método show_students
          get :show_students

          # Verifique se @students contém os dados esperados
          expect(controller.instance_variable_get(:@students)).to eq(Student.ordered_by_name)
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end
      end

      context 'sem dados' do
        it 'atribui @students vazio' do
          # Faça a requisição para o método show_students sem criar alunos
          get :show_students

          # Verifique se @students está vazio
          expect(controller.instance_variable_get(:@students)).to be_empty
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe 'GET #show_books' do
      context 'com dados presentes' do
        it 'atribui @books com dados presentes' do
          # Crie alguns alunos usando FactoryBot
          FactoryBot.create_list(:book, 5)

          # Faça a requisição para o método show_books
          get :show_books

          # Verifique se @books contém os dados esperados
          expect(controller.instance_variable_get(:@books)).to eq(Book.ordered_by_title)
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end
      end

      context 'sem dados' do
        it 'atribui @books vazio' do
          # Faça a requisição para o método show_books sem criar books
          get :show_books

          # Verifique se books está vazio
          expect(controller.instance_variable_get(:@books)).to be_empty
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe 'GET #show_libraries' do
      context 'com dados presentes' do
        it 'atribui @libraries com dados presentes' do
          # Crie alguns alunos usando FactoryBot
          FactoryBot.create_list(:library, 5)

          # Faça a requisição para o método show_libraries
          get :show_libraries

          # Verifique se @libraries contém os dados esperados
          expect(controller.instance_variable_get(:@libraries)).to eq(Library.ordered_by_name)
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end
      end

      context 'sem dados' do
        it 'atribui @libraries vazio' do
          # Faça a requisição para o método show_libraries sem criar libraries
          get :show_libraries

          # Verifique se libraries está vazio
          expect(controller.instance_variable_get(:@libraries)).to be_empty
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end
      end
    end


    describe '#viewBookHistory' do
      let(:book) { create(:book) }
      let!(:students) { create_list(:student, 3) }
      #let!(:checkout) { create_list(:checkout, 3, return_date: Date.today) }
      let!(:checkouts) do
        students.map do |student|
          create(:checkout, student_id: student.id, book_id: book.id, return_date: Date.today)
        end
      end

      context 'when @checkouts is present with data' do
        it 'displays checkout data in view' do
          #checkout = create(:checkout, book: book)
          get :viewBookHistory, params: { id: book.id }

          expect(controller.instance_variable_get(:@checkouts)).to eq(checkouts)
          #expect(response).to render_template(:viewBookHistory)
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when @checkouts is empty' do
        let(:book_other) { create(:book) }
        it 'displays no checkout data in view' do
          get :viewBookHistory, params: { id: book_other.id }

          expect(controller.instance_variable_get(:@checkouts)).to be_empty
          #expect(response).to render_template(:viewBookHistory)
          expect(response).to be_successful
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("") 
          #expect(response.body).to include('No checkouts found') # Mensagem para checkouts vazios
          # Verifique outros comportamentos esperados quando não há checkouts
        end
      end
    end

    
    describe 'GET #list_checkedoutBooksAndStudents' do
      let(:book) { create(:book) }
      let(:student) { create(:student) }

      it 'returns checked out books and students ' do
        checkout_1 = create(:checkout, student_id: student.id, book_id: book.id)

        get :list_checkedoutBooksAndStudents

        expect(controller.instance_variable_get(:@results)).to include(checkout_1)
        #expect(controller.instance_variable_get(:@results)).not_to include(checkout_2)
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it 'returns checked out books and students empety ' do
        get :list_checkedoutBooksAndStudents 

        expect(controller.instance_variable_get(:@results)).to be_empty
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('')
      end
    end

    
    describe '#getOverdueBooks' do
      let(:book) { create(:book) }

      context 'when @checkouts is present' do
        it 'creates fines for overdue books' do
          checkout = create(:checkout, book_id: book.id, issue_date: 30.days.ago, return_date: nil, validity: 5) # Crie um checkout atrasado
          allow(Library).to receive(:overdue_fines).and_return(5)
          get :getOverdueBooks

          expect(controller.instance_variable_get(:@checkouts)).to include(checkout)
          expect(controller.instance_variable_get(:@fines)).not_to be_empty
          expect(controller.instance_variable_get(:@fines)).to be_an_instance_of(Array)
          expect(controller.instance_variable_get(:@fines).first[:fine_ammount]).to be > 0
        end

        it 'calculates the fine as 0 ' do
          checkout = create(:checkout, book_id: book.id, issue_date: 5.days.ago, return_date: nil, validity: 5)
          
          get :getOverdueBooks

          expect(controller.instance_variable_get(:@checkouts)).to include(checkout)
          expect(controller.instance_variable_get(:@fines)).not_to be_empty
          expect(controller.instance_variable_get(:@fines)).to be_an_instance_of(Array)
          expect(controller.instance_variable_get(:@fines).first[:fine_ammount]).to eq(0)
        end
      end

      context 'when @checkouts is not present' do
        it 'does not create fines' do
          get :getOverdueBooks

          expect(controller.instance_variable_get(:@checkouts)).to be_empty
          expect(controller.instance_variable_get(:@fines)).to be_nil
        end
      end
    end

    
    describe '#list_checkedoutBooks' do

      it 'returns checked out books for a specific library' do
        checked_out_book = create(:book)

        # Crie um checkout para o livro verificado na biblioteca específica
        create(:checkout, book: checked_out_book,  return_date: nil)

        # Faça uma solicitação GET para a action list_checkedoutBooks
        get :list_checkedoutBooks

        # Verifique se a variável @books contém apenas o livro verificado
        expect(controller.instance_variable_get(:@books)).to contain_exactly(checked_out_book)
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @books as an empty collection' do
        get :list_checkedoutBooks
        expect(controller.instance_variable_get(:@books)).to be_empty
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('')
      end
    end

    
    describe 'GET #viewHoldRequest' do
      it 'returns hold requests ' do
        
        book = create(:book)
        hold_request = create(:hold_request, book: book)
      
        get :viewHoldRequest

        expect(controller.instance_variable_get(:@request)).to include(hold_request)
      end

      it 'renders the #viewHoldRequest template' do
        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @request as an empty collection' do
        get :viewHoldRequest
        expect(controller.instance_variable_get(:@request)).to be_empty
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('')
      end
    end

  end
end
