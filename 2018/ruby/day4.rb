input = File.read('day4.txt')
sorted_input = input.split("\n").sort.join

guards = {}
shifts = sorted_input.split('Guard #')
shifts.each do |shift|
  id = shift.split(' ')[0].to_i
  shift.scan(/\[([\d\-\s:]{3,})\][^\[]{1,}\[([\d\-\s:]{3,})\]/).each do |match|
    start = match.first.split(':').last.to_i
    stop = match.last.split(':').last.to_i
    guards[id] = {} if guards[id].nil?
    start.upto(stop - 1) do |minute|
      guards[id][minute] = 0 if guards[id][minute].nil?
      guards[id][minute] += 1
    end
  end
end

most_minutes_asleep = 0
solution = 0
most_sleepy_minute_max = 0
most_sleepy_minute_minute = 0
most_sleepy_minute_value = 0
sleepiest_guard = 0
guards.each do |guard|
  minutes_asleep = guard.last.values.sum

  most_sleepy_minute = guard.last.max_by { |key, value| value }.first
  most_sleepy_minute_value = guard.last.max_by { |key, value| value }.last

  if most_sleepy_minute_max < most_sleepy_minute_value
    most_sleepy_minute_max = most_sleepy_minute_value
    most_sleepy_minute_minute = most_sleepy_minute
    sleepiest_guard = guard.first
  end

  next if minutes_asleep < most_minutes_asleep

  most_minutes_asleep = minutes_asleep
  most_sleepy_minute = guard.last.max_by { |key, value| value }.first
  solution = guard.first * most_sleepy_minute
end

puts "Puzzle solution part 1: #{solution}"
puts "Puzzle solution part 2: #{sleepiest_guard * most_sleepy_minute_minute}"
