require 'time'

Given /^(a flight|it) (has|used) "(.+)" (of\s?)?"(.*)"$/ do |_, __, field, ___, value|
  @activity_hash ||= {}
  if value.present?
    methods = field.split('.')
    context = @activity_hash
    methods.each do |method|
      method = method.to_sym
      context[method] ||= {}
      value = Date.parse(value) if value =~ /\d{4}-\d{2}-\d{2}/
      context[method] = value if method == methods.last.to_sym
      context = context[method]
    end
  end
end

Given /^the current date is (.+)$/ do |current_date|
  @current_date = Time.parse(current_date)
end

When /^emissions are calculated$/ do
  @activity = FlightRecord.from_params_hash @activity_hash
  if @current_date
    Timecop.travel(@current_date) do
      @emission = @activity.emission Sniff::Timeframe.this_year
    end
  else
    @emission = @activity.emission Sniff::Timeframe.this_year
  end
end

Then /^the emission value should be within (\d+) kgs of (\d+)$/ do |cusion, emissions|
  @emission.should be_close(emissions.to_f, cusion.to_f)
end

Then /^the calculation should have used committees (.*)$/ do |committee_list|
  committees = committee_list.split(/,\s*/)
  committees.each do |committee|
    @activity.committees.keys.should include(committee)
  end
end

Then /^the (.+) committee should be close to (\d+), \+\/-(\d+)$/ do |committee, cusion, emission|
  @activity.committees[committee].to_f.should be_close(emission.to_f, cusion.to_f)
end

Then /^the (.+) committee should be exactly (.*)$/ do |committee, value|
  @activity.committees[committee].to_s.should == value
end

Then /^the active_subtimeframe committee should have timeframe (.*)$/ do |tf_string|
  days, start, finish = tf_string.split(/,\s*/)
  @activity.committees['active_subtimeframe'].to_s.should =~ /#{days} days starting #{start} ending #{finish}/
end

