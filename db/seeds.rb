# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faker::Config.default_locale = 'pt-BR'

# Tabela subject
def Subject
  tema = [ "Ficção Científica","Fantasia","Romance","Mistério","Suspense","Policial","Aventura","História",
          "Biografia","Não Ficção","Poesia","Clássico","Conto","Autoajuda","Negócios","Autores Locais",
          "Autores Internacionais","História em Quadrinhos","Jovem Adulto","Infantil","Fantasia Épica",
          "História Alternativa","Horror","Literatura Estrangeira","Literatura Nacional","Religião","Autoestima",
          "Desenvolvimento Pessoal","Psicologia","História Mundial","História Americana","Ciência","Tecnologia",
          "Autores Clássicos","Filosofia","Mitologia","Ficção Histórica","Biografia de Celebridade","Viagem",
          "Culinária","Arte","Ciência da Computação","Meio Ambiente","Poesia Contemporânea","Romance de Época",
          "Espiritualidade","Esporte","Política","Economia", "Bio Mecanica"
        ]
  
  50.times do |index|
    nome_tema = tema[index]
    Subject.create!(name: nome_tema)
  end
end

# Tabela nationality
def Nationality
  50.times do
    Nationality.create!(name: Faker::Nation.unique.nationality)
  end
end

# Tabela language
def Language
  # Array com 50 idiomas em ordem crescente
  idiomas = [
    'Inglês', 'Espanhol', 'Chinês', 'Hindi', 'Árabe', 'Português', 'Bengali', 'Russo', 'Japonês', 'Javanês',
    'Alemão', 'Punjabi', 'Marathi', 'Telugu', 'Turco', 'Tâmil', 'Urdu', 'Grego', 'Gujarati', 'Polonês', 'Frances',
    'Ucraniano', 'Italiano', 'Holandês', 'Bielorrusso', 'Malaio', 'Tailandês', 'Vietnamita', 'Sueco', 'Hebraico',
    'Coreano', 'Persa', 'Malaiala', 'Catalão', 'Grego Antigo', 'Latim', 'Sânscrito', 'Tibetano', 'Suaíli', 'Húngaro',
    'Norueguês', 'Dinamarquês', 'Finlandês', 'Irlandês', 'Escocês', 'Galês', 'Esperanto', 'Klingon', 'Quenya', 'Dothraki'
  ]

  # Loop para criar dados usando Faker
  50.times do |index|
    nome_idioma = idiomas[index]
    Language.create!(name: nome_idioma)
  end
end

# Tabela education_level
def EducationLevel 
  education_levels = ['Educação Técnico', 'Ensino Fundamental', 'Ensino Médio',
                      'Ensino Superior', 'Graduação', 'Pós-Graduação', 'Mestrado',
                      'Doutorado', 'Pós-Doutorado', 'Outro' ]

  10.times do |index |
    name = education_levels[index]
    EducationLevel.create!(name: name)
  end
end

# Tabela author
def Author
  50.times do
    domain = "www." + Faker::Internet.unique.domain_name + ".com"
    author = Author.create!(
      name: Faker::Book.unique.author,
      email: Faker::Internet.email,
      website: domain,
      nationality_id: Nationality.all.sample.id
    )

    # Gerar um valor aleatório para o `author_id`
    #author.update!(id: Author.all.last.id + 1)
  end
end

# Tabela publisher
def Publisher
  50.times do
    domain = "www." + Faker::Internet.unique.domain_name + ".com"
    Publisher.create!(
      name: Faker::Book.unique.publisher,
      email: Faker::Internet.email,
      website: domain
    )
  end
end

# Tabela university
def University
  # Cria um registro na tabela `university`
  50.times do |index|
    # Cria um registro na tabela `university`
    domain = "www." + Faker::Internet.unique.domain_name + ".com"
    university = University.create!(
      name: Faker::University.unique.name,
      email: Faker::Internet.email,
      identification: "99.999.999/0001-99",
      homepage: domain
    )
  
    # Cria um registro na tabela `address`
    address = Address.create!(
      street: Faker::Address.street_address,
      number: Faker::Address.building_number,
      complement: Faker::Address.secondary_address,
      neighborhood: Faker::Address.community,
      city: Faker::Address.city,
      state: Faker::Address.state,
      country: Faker::Address.country,
      zipcode: Faker::Address.zip_code,
      university_id: university.id
    )
    # Tabela telephone
    Telephone.create!(
        phone: Faker::PhoneNumber.cell_phone,
        email_contact: Faker::Internet.email,
        contact: Faker::Name.unique.name,
        university_id: university.id
      )
    #Tabela library
    Library.create!(
      name: Faker::Company.unique.name,
      email: Faker::Internet.email,
      borrow_limit: Faker::Number.between(from: 10, to: 30),
      overdue_fines: Faker::Number.decimal(l_digits: 2),
      location: Faker::Address.unique.city,
      university_id: University.all.sample.id
    )
  end
end

# Tabela book
def Book
  100.times do
    lorem_lines = Faker::Lorem.paragraphs(number: 3)
    # Converta o array em uma única string
    lorem_text = lorem_lines.join("\n")
    Book.create!(
      isbn: Faker::Code.unique.isbn,
      title: Faker::Book.unique.title,
      published: Faker::Date.between(from: '1959-01-01', to: '2023-12-31'),
      publication_date: Faker::Date.between(from: '1959-01-01', to: '2023-12-31'),
      edition: '1ª edição',
      cover: Faker::File.file_name,
      summary: lorem_text,
      special_collection: Faker::Boolean.boolean,
      count: rand(1..4),
      library_id: Library.all.sample.id,
      subject_id: Subject.all.sample.id,
      language_id: Language.all.sample.id,
      author_id: Author.all.sample.id,
      publisher_id: Publisher.all.sample.id
    )
  end
end

def Librarian
  10.times do
    Librarian.create!(
      name: Faker::Name.unique.name,
      identification: Faker::IDNumber.brazilian_citizen_number(formatted: true),
      email: Faker::Internet.email,
      password: "12345678",
      phone: Faker::PhoneNumber.cell_phone,
      approved: "YES",
      library_id: Library.all.sample.id
    )
  end
end

def Student
    10.times do
      Student.create!(
        name: Faker::Name.unique.name,
        identification: Faker::IDNumber.brazilian_citizen_number(formatted: true),
        email: Faker::Internet.email,
        password: "12345678",
        phone: Faker::PhoneNumber.cell_phone,
        max_book_allowed:  rand(1..4),
        google_token: "",
        google_refresh_token: "",
        provider: " ",
        uid: " ",
        university_id: University.all.sample.id,
        education_level_id: EducationLevel.all.sample.id
      )
    end
  
end

Book.destroy_all
Author.destroy_all
Librarian.destroy_all
Library.destroy_all
Subject.destroy_all
Nationality.destroy_all
Language.destroy_all
EducationLevel.destroy_all
Publisher.destroy_all
Student.destroy_all
Address.destroy_all
Telephone.destroy_all
University.destroy_all

Nationality()
EducationLevel()
Language()
Subject()
Publisher()
Author()
University()

Book()
Librarian()
Student()