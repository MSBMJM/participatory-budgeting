window.App ||= {}

class App.ProposalsFilter

  budget_max:       0
  budget_from:      0
  budget_to:        0
  campaign_id:      0

  isMonitoring:     false

  $proposalsCont:   null

  $filterMenu:      null


  constructor: ( _isMonitoring, _proposalsCont ) ->

    @isMonitoring   = _isMonitoring
    @$proposalsCont = if _proposalsCont then _proposalsCont else $('.proposals-cont')

    # Get budget variables
    @budget_max  = $('.vote-progress .vote-progress-amount').data('max-amount')   # TODO: check if it's the right way
    @budget_from = $('#budget-range-slider').data('from')
    @budget_to   = $('#budget-range-slider').data('to')
    @campaign_id = $('#budget-range-slider').data('id')
#    @pip_id = $('#budget-range-slider').data('pip')

#    console.log('Data',$('#budget-range-slider').data('id'))
#    console.log('pip',$('#budget-range-slider').data('pip'))
#    console.log('@campaign_id 1:',@campaign_id )
#    console.log('@pip_id 1:',@pip_id )

    @$filterMenu         = $('.proposals-filter-menu')
  
    # Listen changes on filter inputs
    @$filterMenu.find('input.form-check-input, select').change @onFilterChange
    @$filterMenu.find('.card-header').click @onFilterMenuCollapse
    
    # Setup range slider with Ion RangeSlider & listen when update
    #only values from slider is held in this data variable
    $('#budget-range-slider').ionRangeSlider
      onFinish: (data) =>
        @budget_from = data.from
        @budget_to = data.to
        @onFilterChange()

#    console.log('@campaign_id 2:',@campaign_id )


  # Update Proposals filtering
  onFilterChange: =>
    
    # Add visual feedback when filter starts
    @$proposalsCont.css('opacity', 0.5)

    # check if all classifiers are checked
    all_classifiers = true

    # Get selected classifiers ids
    classifiers = $('#classifier-district').val()
    if classifiers.indexOf(',') == -1
      all_classifiers = false
    present_classifiers = @$filterMenu.find('input.form-check-input').length
#    console.log('Filter Len: ', present_classifiers)
    checked_count = 0
    @$filterMenu.find('input.form-check-input').each () ->
#      console.log('ID: ',$(this).val())
      if $(this).is(':checked')
        classifiers = classifiers+','+ $(this).val()
        checked_count += 1
#      else
#        all_classifiers = false
    if present_classifiers isnt checked_count
      all_classifiers = false
#    console.log('check Count: ', checked_count)
#    console.log('Classifiers',classifiers)
#    console.log('All classifiers',all_classifiers)
#    console.log('Campaign ID 3:',@campaign_id)
##    console.log('pip_id ID 3:',@pip_id)
#    console.log('@budget_from:',@budget_from)

    # Send ajax petition to proposals filter
    $.ajax(
      url: if @isMonitoring then '/monitoring/proposals' else '/voting/proposals'
      data: 
        class: if all_classifiers then '' else classifiers  # if all classifiers are checked we don't send class params
        budget_min: @budget_from
        budget_max: @budget_to
        id: @campaign_id

      type: 'GET'
    ).done (data) =>
      if data.proposals_ids
        # Show only returned proposals ids
        @$proposalsCont.find('.proposal').hide()

        if data.proposals_ids.length > 0
          $('#proposals-filter-empty').hide()
          data.proposals_ids.forEach (id) ->
            $('#proposal-'+id).show()
          @$proposalsCont.css('opacity', 1)
        else
          $('#proposals-filter-empty').show()
          @$proposalsCont.css('opacity', 1)
        
  # Make filter menú collapsable
  onFilterMenuCollapse: =>
    if @$filterMenu.find('.arrow').css('display') == 'block'
      @$filterMenu.find('.card-block').toggle()
      @$filterMenu.find('.arrow').toggleClass('collapsed')
