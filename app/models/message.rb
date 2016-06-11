class Message < ActiveRecord::Base
  validates_presence_of :sender
  validates_presence_of :message
  validates_format_of :email, with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
end
