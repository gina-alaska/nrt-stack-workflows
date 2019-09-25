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
# Set up requirements
steps[:rtstps].requirements = %w{aapp}.map do |requirement|
  Requirement.where(name: requirement).first_or_create
end
sat = Satellite.friendly.find('gcom-w')
sat.workflows << steps[:arrival] unless sat.workflows.include?(steps[:arrival])
