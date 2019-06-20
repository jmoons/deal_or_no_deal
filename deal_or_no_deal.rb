class DealOrNoDeal

  ALL_CASE_VALUES_CENTS = [
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
    @active_cases_for_this_game = ALL_CASE_VALUES_CENTS.shuffle

    # Get the Player's case
    player_case = prompt_player_for_input( "Please Select Your Case (1 - #{ALL_CASE_VALUES_CENTS.length}):", ("1"..ALL_CASE_VALUES_CENTS.length.to_s) ).to_i

    # Now remove Player's case from the this game's active cases while simultaneously capturing its value
    @player_case_value = remove_player_case_from_active_cases(player_case)

    # Create a container to hold cases as they are eliminated from play
    @expunged_cases_in_game = []

    @number_of_cases_to_remove = 6

    continue_game

  end

  def continue_game
    @active_cases_for_this_game.length == 1 ? end_game : play_round
  end

  private

  def play_round
    # Remove this round's number of cases from the game. Because we shuffled the cases, we can just 
    # pop values off the array as in the real game on TV, the act of selecting cases to remove
    # is a statistically random event
    cases_expunged_in_this_round = @active_cases_for_this_game.pop(@number_of_cases_to_remove)

    # Keep track of all the removed cases in the game
    @expunged_cases_in_game.concat( cases_expunged_in_this_round )

    # Decrement the number of cases to remove if there is a next round
    update_number_of_cases_to_remove

    # Get the Banker's offer based off this round's happenings
    @banker_offer = get_banker_offer()

    # Tell the player the scoop
    relay_situation_to_player( cases_expunged_in_this_round )
  end

  def update_number_of_cases_to_remove
    @number_of_cases_to_remove -= 1 unless @number_of_cases_to_remove == 1
  end

  def relay_situation_to_player( cases_expunged_in_this_round )
    cases_still_in_play = ALL_CASE_VALUES_CENTS.reject{|case_value| @expunged_cases_in_game.include?(case_value)}

    puts "Cases Eliminated   : #{cases_expunged_in_this_round.map{|case_value| convert_cents_to_dollars(case_value)}}"
    puts "Cases Still In Play: #{cases_still_in_play.map{|case_value| convert_cents_to_dollars(case_value)}}"
    puts "Banker Offers: #{convert_cents_to_dollars(@banker_offer)}"

    player_take_deal_reply = prompt_player_for_input("Take the deal? y or n.", ["y", "n"])

    player_take_deal_reply == "y" ? took_banker_offer : continue_game

  end

  def end_game
    puts "\nYou played until the end!"
    puts "You turned down the final banker offer of: #{convert_cents_to_dollars(@banker_offer)}"
    puts "\nYour case had:               #{convert_cents_to_dollars(@player_case_value)}"
    puts "The last remaining case had: #{convert_cents_to_dollars(@active_cases_for_this_game[0])}"

  end

  def took_banker_offer
    puts "\nYou took the banker offer of: #{convert_cents_to_dollars(@banker_offer)}"
    puts "Your case had:                #{convert_cents_to_dollars(@player_case_value)}"
  end

  def convert_cents_to_dollars(cents_value)
    (cents_value / 100.00).round(2)
  end

  def get_banker_offer
    # Still tinkering with the formula here - generally I want to offer less the more cases are still in play

    # Get the average case value but include the player's case in the average
    average_active_case_value = ( @active_cases_for_this_game.inject(:+) + @player_case_value) / ( @active_cases_for_this_game.length + 1 ).to_f

    # Penalize the offer as a function of the number of cases in play - more cases = higher penaly, less cases = lower penalty
    # Add the player's case into the active case total to keep in step with the average above
    banker_offer = average_active_case_value * ( 1.0 - ( (@active_cases_for_this_game.length + 1) / ALL_CASE_VALUES_CENTS.length.to_f) )

  end

  def remove_player_case_from_active_cases(case_to_remove)
    @active_cases_for_this_game.slice!( case_to_remove - 1 )
  end

  def prompt_player_for_input(input_prompt_text, valid_input_criteria)
    # valid_input_criteria must be an object that supports the include? method
    # Return value will be a string, any desired typing must be performed by the caller

    valid_input = false

    while !valid_input
      puts input_prompt_text
      player_input  = gets
      player_input  = player_input.chomp.downcase
      valid_input = valid_input_criteria.include?( player_input )
    end

    player_input
  end

end

DealOrNoDeal.new()