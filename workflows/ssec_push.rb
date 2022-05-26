steps = {}
#noaa20
steps[:noaa_l0] = Step.where(name: "Snoaa20RtstpsJob").first

steps[:noaa20_push] = Step.where(name: "Noaa20SSECPush").first_or_create({
  command: "ssec_push.rb -s {{job.facility_name.downcase}} -t . {{job.input_path}} ",
  queue: 'cspp_extras',
  producer: false,
  parent: steps[:noaa_l0]
})
#snpp
steps[:snpp_l0] = Step.where(name: "SnppRtstpsJob").first
steps[:noaa20_push] = Step.where(name: "SnppSSECPush").first_or_create({
  command: "ssec_push.rb -s {{job.facility_name.downcase}} -t . {{job.input_path}} ",
  queue: 'cspp_extras',
  producer: false,
  parent: steps[:snpp_l0]
})


