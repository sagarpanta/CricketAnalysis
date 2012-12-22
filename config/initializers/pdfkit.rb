# config/initializers/pdfkit.rb
PDFKit.configure do |config|
   config.wkhtmltopdf = 'wkhtmltopdf.exe'
   config.default_options = {
     :page_size => 'Legal',
     :print_media_type => true
   }
   config.root_url = "http://shrouded-crag-2242.herokuapp.com" # Use only if your external hostname is unavailable on the server.
end