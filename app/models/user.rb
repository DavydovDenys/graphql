# frozen_string_literal: true

class User < ApplicationRecord
  has_many :projects, dependent: :destroy
  validates :name, presence: true, length: { minimum: 2 }
end
