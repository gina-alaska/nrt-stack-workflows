

## NOAA21
steps = {}
steps[:arrival] = Step.where(name: 'Noaa21Arrival').first_or_create({
  processing_level: ProcessingLevel.where(name: 'raw').first_or_create
})
steps[:rtstps] = Step.where(name: "SNoaa21RtstpsL0Job").first_or_create({
  command: "rtstps.rb -p noaa21 -t {{workspace}} {{job.input_file}} {{job.output_path}}",
  queue: 'rtstps',
  processing_level: ProcessingLevel.where(name: 'level0-ipopp').first_or_create,
  parent: steps[:arrival]
})


## NOAA20
steps = {}

steps[:arrival] = Step.where(name: 'Noaa20Arrival').first_or_create({
  processing_level: ProcessingLevel.where(name: 'raw').first_or_create
})
steps[:rtstps] = Step.where(name: "Snoaa20RtstpsL0Job").first_or_create({
  command: "rtstps.rb -p noaa20 -t {{workspace}} {{job.input_file}} {{job.output_path}}",
  queue: 'rtstps',
  processing_level: ProcessingLevel.where(name: 'level0-ipopp').first_or_create,
  parent: steps[:arrival]
})

## SNPP
steps = {}

steps[:arrival] = Step.where(name: 'SnppArrival').first_or_create({
  processing_level: ProcessingLevel.where(name: 'raw').first_or_create
})
steps[:rtstps] = Step.where(name: "SnppRtstpsL0Job").first_or_create({
  command: "rtstps.rb -p npp -t {{workspace}} {{job.input_file}} {{job.output_path}}",
  queue: 'rtstps',
  processing_level: ProcessingLevel.where(name: 'level0-ipopp').first_or_create,
  parent: steps[:arrival]
})
