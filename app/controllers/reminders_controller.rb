class RemindersController < ApplicationController
	def create
		user_id = params[:reminder][:user_id]
		part_id = params[:reminder][:part_id]

		if Reminder.where(part_id: part_id, user_id: user_id).exists?
			reminder = Reminder.where(part_id: part_id, user_id: user_id).first
			reminder.update_attribute(:updated_at, Time.now)
			flash[:success] = "You will receive an email when this part is back in stock"
			redirect_to :back
		else
			reminder = Reminder.new(reminder_params)
			if reminder.save
				flash[:success] = "You will receive an email when this part is back in stock"
		    redirect_to :back
		  end
		end
	end

	private 

	def reminder_params
    params.require(:reminder).permit(:part_id, :user_id)
  end
end
