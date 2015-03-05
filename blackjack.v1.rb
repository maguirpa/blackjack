suits = ["Hearts", "Diamonds", "Spades", "Clubs"]
suit_values = ['2', '3', '4', '5', '6', '7','8', '9', '10', 'Jack', 'Queen','King', 'Ace']

def calculate_total(hand)
  arr = hand.map{|card| card[1] }

  card_total = 0
  arr.each do |card|
    if card == 'Ace'
      card_total += 11
    elsif card.to_i == 0
      card_total += 10
    else
      card_total += card.to_i
    end
  end
  arr.select{|aces| aces == 'Ace'}.count.times do
    card_total -= 10 if card_total > 21
  end
  card_total
end   

def player_pick
  begin
    puts "Would you like to stay(s) or hit(h)?"
    player_response = gets.chomp.downcase
  end until player_response == 's' || player_response == 'h'
  player_response
end

def player_hit (player_hand, shuffled_deck)
  new_card = shuffled_deck.pop
  puts "\nYour hit dealt you the #{new_card[1]} of #{new_card[0]}."
  player_hand << new_card
  player_hand
end

def computer_hit(computer_hand, shuffled_deck)
  new_card = shuffled_deck.pop
  puts "\nComputer hit dealt the #{new_card[1]} of #{new_card[0]}."
  computer_hand << new_card
  computer_hand
end

def stay(hand)
  puts "\nYour card total is #{calculate_total(hand)}."
end

def check_for_bust(player_hand)
  calculate_total(player_hand) > 21
end

def computer_play(computer_hand, shuffled)
  loop do
    if calculate_total(computer_hand) < 17
      computer_hit(computer_hand, shuffled)
    end
    break if check_for_bust(computer_hand) || calculate_total(computer_hand) >= 17
  end
  if check_for_bust(computer_hand)
    puts "\nComputers card total is #{calculate_total(computer_hand)}." 
    puts "Computer Busts!"
  else
    puts "\nComputers card total is #{calculate_total(computer_hand)}."   
  end
end

def check_for_blackjack(hand)
  calculate_total(hand) == 21
end

def display_winner(computer_hand, player_hand)
  if check_for_bust(player_hand)
    puts "\nComputer wins!"
  elsif check_for_bust(computer_hand)
    puts "\nPlayer wins!"
  elsif calculate_total(player_hand) > calculate_total(computer_hand)
    puts "\nPlayer wins!"
  elsif calculate_total(player_hand) == calculate_total(computer_hand)
    puts "\nIt's a draw."
  else
    puts "\nComputer wins!"
  end
end
      
begin
  system 'clear'
  deck = suits.product(suit_values)
  shuffled_deck = deck.shuffle!
  player_hand = [shuffled_deck.pop, shuffled_deck.pop]
  computer_hand = [shuffled_deck.pop, shuffled_deck.pop]

  puts "\nYou were dealt the #{player_hand[0][1]} of #{player_hand[0][0]} and #{player_hand[1][1]} of #{player_hand[1][0]}."
  puts "\nYour card total is #{calculate_total(player_hand)}."
  puts "\nThe Computers first card is the #{computer_hand[0][1]} of #{computer_hand[0][0]}."
  if check_for_blackjack(player_hand)
    puts "Player got blackjack! Player wins!"
    next
  else
    begin
      if player_pick == 's'
        stay(player_hand)
        break
      else
        player_hit(player_hand,shuffled_deck)
        puts "\nYour card total is #{calculate_total(player_hand)}." 
        check_for_bust(player_hand)
        if check_for_bust(player_hand)
          puts "Player busted!"
          break
        end
      end 
    end while true
  end
  puts "\nComputer was dealt the #{computer_hand[0][1]} of #{computer_hand[0][0]} and #{computer_hand[1][1]} of #{computer_hand[1][0]}."
  if !check_for_bust(player_hand)
    if check_for_blackjack(computer_hand)
      puts "\nComputer got blackjack. :-("
    else
      computer_play(computer_hand, shuffled_deck)
    end
  end
  display_winner(computer_hand, player_hand)
  puts "\nPlay again? (y/n)"
  play_again = gets.chomp.downcase
end until play_again == 'n'
