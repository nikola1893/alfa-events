class User < ApplicationRecord
  has_many :tickets
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :rememberable,
         :validatable

  def remaining_tickets
    limit - tickets.count
  end

end
