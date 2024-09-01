class HomePageController < ApplicationController
    def index
        if !current_student.nil?
            sign_out :stuednt
        end
        if !current_admin.nil?
            sign_out :admin
            print("adm = #{sign_out}")
        end
        if !current_librarian.nil?
            sign_out :librarian
        end
    end
end
