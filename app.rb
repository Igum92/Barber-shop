require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	@db = SQLite3::Database.new 'barbershop.db'
	@db.execute 'CREATE TABLE 
		"Users" 
		(
			"Id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"Name" TEXT, "Phone" TEXT, "DateStamp" TEXT,
			"Barber" TEXT,
			"Color" TEXT
		)'

end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error='Something!'
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	hh = {  :username => 'Введите имя', 
			:phone => 'Введите телефон', 
			:datetime => 'Введите дату и время'}

	hh.each do |key, value|

		if params[key]==''

			@error=hh[key]
			return erb :visit
		end

	end



	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"

end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
 	@comment = params[:comment]

	@title="Спасибо!"
	@message="Спасибо! Нам важен Ваш комментарий"

	f=File.open './public/contacts.txt','a'
	f.write "Комментарий: #{@comment}, "
	f.flush
	hh = {  :comment => 'А комментарий ввести? Забыли?' }


	
	hh.each do |key, value|
		if params[key]==''
			@error=hh[key]
			return erb :contacts
		end
	end	

	erb :message_comment	
										
end 


