steps = Hash.new
# Set up steps
steps[:arrival] = Step.where(name: "GComWArrival").first_or_create({
  processing_level: ProcessingLevel.where(name: 'raw').first_or_create
  })
steps[:rtstps] = Step.where(name: "GcomwRtstpsJob").first_or_create({
  command: "rtstps.rb -p gcomw -t {{workspace}} {{job.input_file}} {{job.output_path}}",
  queue: 'rtstps',
  processing_level: ProcessingLevel.where(name: 'level0').first_or_create,
  parent: steps[:arrival]
})


#GCOMW Level1 
steps[:level1] = Step.where(name: "Amsr2Level1").first_or_create({
  command: "amsr2_level1.rb -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: "cspp_extras",
  processing_level: ProcessingLevel.where(name: 'level1').first_or_create,
  sensor: Sensor.where(name: 'amsr2').first_or_create,
  parent: steps[:rtstps]
})


#SCMI
steps[:scmi] = Step.where(name: "Amsr2Scmi").first_or_create({
  command: "awips_scmi.rb  -m amsr2_l1b -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: "polar2grid",
  processing_level: ProcessingLevel.where(name: 'scmi').first_or_create,
  sensor: Sensor.where(name: 'amsr2').first_or_create,
  parent: steps[:level1]
})
#Geotif
steps[:gtiff] = Step.where(name: "Amsr2Gtif").first_or_create({
  command: "p2g_geotif.rb -m amsr2  -t {{workspace}} {{job.input_path}} {{job.output_path}}",
  queue: "polar2grid",
  processing_level: ProcessingLevel.where(name: 'geotiff_l1').first_or_create,
  sensor: Sensor.where(name: 'amsr2').first_or_create,
  parent: steps[:level1]
})



# Set up requirements
steps[:rtstps].requirements = %w{aapp}.map do |requirement|
  Requirement.where(name: requirement).first_or_create
end
sat = Satellite.friendly.find('gcom-w')
sat.workflows << steps[:arrival] unless sat.workflows.include?(steps[:arrival])
