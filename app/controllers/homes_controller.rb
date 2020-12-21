# frozen_string_literal: true

class HomesController < ApplicationController
  def index
    @new_tickets = Ticket.order('created_at DESC').limit(8)
    # @hot_tickets = Ticket.all.limit(8).sort { |a, b| b.likes.count <=> a.likes.count }
    @hot_tickets = Ticket.all.sort { |a, b| b.likes.count <=> a.likes.count }
    @hot_tickets = @hot_tickets[0..7]
  end
end
