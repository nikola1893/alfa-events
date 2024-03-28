class Ticket < ApplicationRecord
  belongs_to :user

  private

  def self.print_qr_codes
    desktop_folder_path = File.expand_path("~/Desktop/alfa-tickets")
    all.each_with_index do |ticket, i|
      qrcode = RQRCode::QRCode.new("https://alfa-events-bafea2c349ed.herokuapp.com/tickets/#{ticket.token}/enter")
      qr = qrcode.as_png(
        resize_gte_to: false,
        resize_exactly_to: false,
        offset: 7,
        color: 'black',
        size: 200,
        file: nil
      )
  
      qr_image = ChunkyPNG::Image.from_blob(qr.to_s)
  
      ticket_image = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/ticket-design.png")
      y_offset = 278
      x_offset = 825
      ticket_image.compose!(qr_image, x_offset, y_offset)

      token_images = {}
      # ('a'..'z').each { |char| token_images[char] = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/#{char}.png") }
      ('a'..'z').each do |char|
        image = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/#{char}.png")
        # Make the image 50% transparent
        image.compose!(ChunkyPNG::Image.new(image.width, image.height, ChunkyPNG::Color::TRANSPARENT), 0, 0)
        token_images[char] = image
      end
      ('0'..'9').each { |char| token_images[char] = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/#{char}.png") }

      x_offset = 200
      y_offset = 20
      ticket.token.each_char do |char|
        ticket_image.compose!(token_images[char.downcase], x_offset, y_offset)
        x_offset += token_images[char.downcase].width - 1
      end
    
      ticket_image.save("#{desktop_folder_path}/tickets/#{ticket.token}.png", :fast_rgba)
      puts "Ticket #{i + 1} saved to #{desktop_folder_path}/tickets/#{ticket.token}.png"
    end
    puts "🎉 Done"
  end
   
  
end
