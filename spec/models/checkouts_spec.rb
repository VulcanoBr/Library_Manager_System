# spec/models/checkouts_spec.rb
require 'rails_helper'

RSpec.describe Checkout, type: :model do
  describe ".checkedout_books_and_students" do
    context "quando a library_id é especificada" do
      let(:library_id) { create(:library) } #{ 1 }
      let(:book) { create(:book, library_id: library_id.id) }
      let(:student) { create(:student) }
      let!(:checkout_with_library_id) { create(:checkout, student_id: student.id, book_id: book.id) }
      let!(:checkout_without_library_id) { create(:checkout) }
    
      it "retorna apenas os checkouts com a library_id especificada" do
        results = Checkout.checkedout_books_and_students(library_id.id)
        expect(results).to include(checkout_with_library_id)
        expect(results).not_to include(checkout_without_library_id)
      end

      it 'returns checked out books and students for a specific library with selected fields' do
        checkout = create(:checkout, book: create(:book, library_id: library_id.id))
  
        results = Checkout.checkedout_books_and_students(library_id.id)
  
        expect(results.to_sql).to match(/"students"."id"/)
        expect(results.to_sql).to match(/"students"."name"/)
        expect(results.to_sql).to match(/"students"."email"/)
        # Adicione aqui verificações para outros campos selecionados no select do scope
        expect(results.to_sql).to match(/"books"."isbn"/)
        expect(results.to_sql).to match(/"books"."title"/)
  
        expect(results).to include(checkout)
      end
    end
    
    context "quando a library_id não é especificada" do
      let!(:checkout_1) { create(:checkout) }
      let!(:checkout_2) { create(:checkout) }
    
      it "retorna todos os checkouts for a without specific library with selected fields" do
        results = Checkout.checkedout_books_and_students
        expect(results).to include(checkout_1)
        expect(results).to include(checkout_2)

        expect(results.to_sql).to match(/"students"."id"/)
        expect(results.to_sql).to match(/"students"."name"/)
        expect(results.to_sql).to match(/"students"."email"/)
        # Adicione aqui verificações para outros campos selecionados no select do scope
        expect(results.to_sql).to match(/"books"."isbn"/)
        expect(results.to_sql).to match(/"books"."title"/)
      end
    
    
    end
    
    
  end
end