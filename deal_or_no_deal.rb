class DealOrNoDeal

  ALL_CASE_VALUES = [
    1,
    100,
    500,
    1000,
    2500,
    5000,
    7500,
    10000,
    20000,
    30000,
    40000,
    50000,
    75000,
    100000,
    500000,
    1000000,
    2500000,
    5000000,
    7500000,
    10000000,
    20000000,
    30000000,
    40000000,
    50000000,
    75000000,
    100000000
  ]

  def initialize()
    # Shuffle up our cases for this game!
    @active_cases_for_this_game = ALL_CASE_VALUES.shuffle

    # Get the User's case
    user_case = prompt_user_for_input( "Please Select Your Case (1 - #{ALL_CASE_VALUES.length}):", ("1"..ALL_CASE_VALUES.length.to_s) ).to_i

    # Now remove User's case from the this game's active cases while simultaneously capturing its value
    @user_case_value = remove_user_case_from_active_cases(user_case)

    # Create a container to hold cases as they are eliminated from play
    @expunged_cases_in_game = []

    @number_of_cases_to_remove = 6

    is_game_still_active?

  end

  def is_game_still_active?
    @active_cases_for_this_game.length == 1 ? end_game : play_round
  end

  private

  def play_round
    cases_expunged_in_this_round = @active_cases_for_this_game.pop(@number_of_cases_to_remove)
    @expunged_cases_in_game.concat( cases_expunged_in_this_round )
    update_number_of_cases_to_remove
    relay_situation_to_user( cases_expunged_in_this_round )
  end

  def update_number_of_cases_to_remove
    @number_of_cases_to_remove -= 1 unless @number_of_cases_to_remove == 1
  end

  def relay_situation_to_user( cases_expunged_in_this_round )
    cases_still_in_play = ALL_CASE_VALUES.reject{|case_value| @expunged_cases_in_game.include?(case_value)}

    @banker_offer = get_banker_offer()
    puts "Cases Eliminated   : #{cases_expunged_in_this_round.map{|case_value| convert_cents_to_dollars(case_value)}}"
    puts "Cases Still In Play: #{cases_still_in_play.map{|case_value| convert_cents_to_dollars(case_value)}}"
    puts "Banker Offers: #{convert_cents_to_dollars(@banker_offer)}."

    user_deal_or_no_deal_reply = prompt_user_for_input("Take the deal? y or n.", ["y", "n"])

    user_deal_or_no_deal_reply == "y" ? took_banker_offer : is_game_still_active?

  end

  def end_game
    puts "You played until the end, turning down final banker offer of: #{convert_cents_to_dollars(@banker_offer)}"
    puts "Your case had:               #{convert_cents_to_dollars(@user_case_value)}"
    puts "The last remaining case had: #{convert_cents_to_dollars(@active_cases_for_this_game[0])}"

  end

  def took_banker_offer
    puts "You took the banker offer of #{convert_cents_to_dollars(@banker_offer)}"
    puts "Your case had: #{convert_cents_to_dollars(@user_case_value)}"
  end

  def convert_cents_to_dollars(cents_value)
    cents_value / 100.00
  end

  def get_banker_offer()
    @active_cases_for_this_game.inject(:+) / (@active_cases_for_this_game.length / 0.30)
  end

  def remove_user_case_from_active_cases(case_to_remove)
    @active_cases_for_this_game.slice!( case_to_remove - 1 )
  end

  def prompt_user_for_input(input_prompt_text, valid_input_criteria)
    # valid_input_criteria must be an object that supports the include? method
    # Return value will be a string, any desired typing must be performed by the caller

    valid_input = false

    while !valid_input
      puts input_prompt_text
      user_input  = gets
      user_input  = user_input.chomp.downcase
      valid_input = valid_input_criteria.include?( user_input )
    end

    user_input
  end

end

DealOrNoDeal.new()