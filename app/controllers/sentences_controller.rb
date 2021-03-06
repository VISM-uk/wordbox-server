class SentencesController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authenticate_user!
	def create
		@sentence = Sentence.new

		if params[:user_id]
			@sentence.user_id = params[:user_id]
		else
			@sentence.user_id = current_user.id
		end

		if @sentence.save!
			words = params["words"]

			words.each_with_index do |word, index|
				@word = Word.new
				@word.order = index
				@word.text = word
				@word.sentence = @sentence
				@word.save
			end

			render json: @sentence
		else
			render json: {}, status: 400
		end
	end

	def show 
		@sentence = Sentence.find params[:id]
		render json: @sentence
	end

	private 
	 def sentence_params
	 	params.permit(:user_id, words: [])
	 end
end
