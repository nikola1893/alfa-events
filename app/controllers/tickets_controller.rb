require 'postmark'
class TicketsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :enter]
  before_action :total

  def index
    if current_user.kind == "prodavac"
      redirect_to tickets_new_path
    elsif current_user.kind == "admin"
      @sellers = User.where(kind: ["prodavac", "admin"])
    else
      
    end
  end

  def show
    @ticket = Ticket.find_by(token: params[:token])
    qrcode = RQRCode::QRCode.new("https://www.alfatickets.mk/tickets/#{@ticket.token}/enter")
    @svg = qrcode.as_svg(
      color: :black,
      offset: 12,
      fill: :white,
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true,
      use_path: true
    )
  end

  def new
    if current_user.kind == "prodavac" || current_user.kind == "admin"
      @ticket = Ticket.new    
      @sold = current_user.tickets.count
      @limit = current_user.limit
    end
  end

  def create
    email = params[:ticket][:email]
    number_of_tickets = params[:ticket][:number_of_tickets].to_i
    ticket_urls = []
  
    if email.present? && number_of_tickets.positive?
      if number_of_tickets <= current_user.remaining_tickets
        number_of_tickets.times do
          ticket = Ticket.new(email: email, prodaden: false)
          ticket.user = current_user
          ticket.token = SecureRandom.hex(4)
          ticket.save
          ticket_urls << ticket_url(ticket.token)
        end

        client = Postmark::ApiClient.new(ENV['POSTMARK_API_TOKEN'])

        client.deliver(
          from: 'info@alfatickets.mk',
          to: email,
          subject: 'Купивте тикети',
          html_body: "<div style='font-family: Arial, sans-serif; padding: 20px; background-color: #f5f5f5;'><h2 style='color: #333;'>Повелете тикети за евентот:</h2>#{ticket_urls.each_with_index.map { |url, index| '<a href="' + url + '" style="display: block; margin-bottom: 10px; padding: 10px; background-color: #F38025; color: white; text-decoration: none; text-align: center; border-radius: 5px;">Тикет ' + (index + 1).to_s + '</a>' }.join('')}<p style='color: #333;'><em>Click on the buttons above to access your tickets.</em></p></div>",

          track_opens: true,
          message_stream: 'outbound')
  
        redirect_to tickets_path, notice: "#{number_of_tickets} успешно продадени"
      else
        redirect_to tickets_path, alert: "Неможе да продадете толку тикети"
      end
    else
      redirect_to tickets_path, alert: "Внесете валиден емаил и број на тикети"
    end
  end
  

  def enter
    @ticket = Ticket.find_by(token: params[:token])
    
    if current_user.present? && current_user.kind == "doorman"
      if @ticket.vazecka == true
        @ticket.update!(vazecka: false)
        flash[:notice] = "Валиден тикет!"
      else
        flash[:alert] = "Невалиден тикет!"
      end
      redirect_to ticket_path(@ticket.token)
    else
      redirect_to "https://alfaeventsteam.wixsite.com/alfaevents", allow_other_host: true
    end
  end

  def total
    @total = Ticket.all.count
    @entered = Ticket.where(vazecka: false).count
  end


  private

  def ticket_params
    params.require(:ticket).permit(:email)
  end
end
