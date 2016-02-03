require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exist? db, name
	db.execute('select * from Barbers where Name=?', [name]).length > 0
end
	
def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exist? db, barber
			db.execute 'insert into Barbers (Name) values(?)',[barber]
		end
	end
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash=true
	return db
end

before do
	db=get_db
	@barbers = db.execute 'select * from Barbers order by id desc'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users" 
		(
			"Id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"Name" TEXT, "Phone" TEXT, "DateStamp" TEXT,
			"Barber" TEXT,
			"Color" TEXT
		)'

	db.execute 'CREATE TABLE IF NOT EXISTS
		"Barbers" 
		(
			"Id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"Name" TEXT
		)'
	seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fringman', 'Whill Smith']
	
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error='Something!'
	erb :about
end

get '/visit' do
	db=get_db
	@results = db.execute 'select * from Barbers order by id desc'
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

	db=get_db
	db.execute 'insert into Users 
	(
		Name,
		Phone,
		DateStamp,
		Barber,
		Color
	)
	values(?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]


	erb "<h3> Спасибо! Вы записались! </h3>"

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

get '/showusers'do
	db=get_db
	@results = db.execute 'select * from Users order by id desc'
	erb :showusers                                     
end