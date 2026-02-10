steps = {}

steps[:arrival] = Step.where(name: 'AwsArrival').first_or_create({
  processing_level: ProcessingLevel.where(name: 'raw').first_or_create
})
steps[:rtstps] = Step.where(name: "AwsRtstpsJob").first_or_create({
  command: "rtstps.rb -p aws -t {{workspace}} {{job.input_file}} {{job.output_path}}",
  queue: 'rtstps',
  processing_level: ProcessingLevel.where(name: 'level0').first_or_create,
  parent: steps[:arrival]
})


#AWS Level1
steps[:level1] = Step.where(name: "AwsLevel1Job").first_or_create({
  command: "aws_level1.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: "cspp_extras",
  processing_level: ProcessingLevel.where(name: 'level1').first_or_create,
  sensor: Sensor.where(name: 'mwr').first_or_create,
  parent: steps[:rtstps]
})
