(function() {
    var container = $('.container-fellow-spend-inner');
    
    function build(fellow, node) {
	var r = 50;
	var color = {
	    'People': '#a1624f',
	    'Printing': '#768388',
	    'Overheads': '#e3af24',
	    'Marketing': '#8b8099',
	    'Software': '#8ca595',
	    'Stipends': '#4c606d',
	    'Distribution': '#e8c79a',
	    'Travel': '#b6a691',
	    'Legal fees': '#8db5cf',
	    'Events': '#577844',
	    'Infrastructure': '#2F4243'
	};
	var spend = fellow_spend[fellow];
	var total = 0;
	for (i=0; i<spend.length; i++) {
	    total += spend[i].amount;
	}
	
	var vis = d3.select(node).select('svg');
	vis.data(spend);

	var arc = d3.svg.arc()
	    .outerRadius(r/2);
	
	var pie = d3.layout.pie()
	    .value(function(d) { return d.amount; });
	
	var arcs = vis.selectAll('g.slice')
	    .data(pie(spend))
	    .enter()
	    .append('svg:g')
            .attr('class', function(d, i) { return 'slice slice-'+spend[i].label.toLowerCase(); } );
	
	arcs.append('svg:path')
            .attr('d', arc.outerRadius(r*0.2))
	    .transition()
	    .delay(250)
	    .duration(500)
	    .attrTween('d',  function(d, i, a) {
		return function(t) {
		    return arc.outerRadius((r/2)+(r/2)*t)(d);
		};
	    });
	
	arcs.append('svg:text')
	    .attr('class', 'label')
            .attr('transform', function(d) {
		d.innerRadius = r*0.8;
		d.outerRadius = r*0.8;
		return 'translate(' + arc.innerRadius(r*0.6).outerRadius(r).centroid(d) + ')';
	    })
	    .attr('text-anchor', 'middle')
	    .attr('dy', '0.35em')
	    .text(function(d, i) {
		var percent = d.value*100 / total;
		if (percent < 5) { return '' }
		return percent.toFixed(0)+'%';
	    });
	
	$('.fellow-container').last().after(node);
    }
    
    function update() {
	if (container.find('.fellow-spend-entry-next').length) {
	    $('.fellow-spend-arrow-right').show();
	} else {
	    $('.fellow-spend-arrow-right').hide();
	}
	if (container.find('.fellow-spend-entry-previous').length) {
	    $('.fellow-spend-arrow-left').show();
	} else {
	    $('.fellow-spend-arrow-left').hide();
	}
	
	var fellow = container.find('.fellow-spend-entry-active').data('fellow');
	container.find('.fellow-spend-dot').removeClass('fellow-spend-dot-active');
	container.find('.fellow-spend-dot[data-fellow="'+fellow+'"]').addClass('fellow-spend-dot-active');
	var chart = container.find('.fellow-spend-entry-active .chart-deferred');
	if (chart.length) {
	    build(chart.first().data('fellow'), chart.first()[0]);
	}
	chart.removeClass('.chart-deferred');
    }
    
    container.on('click', '.fellow-spend-arrow-right', function() {
	var next = container.find('.fellow-spend-entry-next').first();
	if (next.length) {
	    container.find('.fellow-spend-entry-active').removeClass('fellow-spend-entry-active').addClass('fellow-spend-entry-previous')
	    next.removeClass('fellow-spend-entry-next').addClass('fellow-spend-entry-active')
	}
	update();
    });
    container.on('click', '.fellow-spend-arrow-left', function() {
	var prev = container.find('.fellow-spend-entry-previous').last();
	if (prev.length) {
	    container.find('.fellow-spend-entry-active').removeClass('fellow-spend-entry-active').addClass('fellow-spend-entry-next')
	    prev.removeClass('fellow-spend-entry-previous').addClass('fellow-spend-entry-active');
	}
	update();
    });
    container.on('click', '.fellow-spend-dot', function() {
	var fellow = $(this).data('fellow');
	var found = false;
	container.find('.fellow-spend-entry').each(function() {
	    var entry = $(this);
	    if (entry.data('fellow') == fellow) {
		entry.removeClass('fellow-spend-entry-next');
		entry.removeClass('fellow-spend-entry-previous');
		entry.addClass('fellow-spend-entry-active');
		found = true;
	    } else if (found) {
		entry.removeClass('fellow-spend-entry-active');
		entry.removeClass('fellow-spend-entry-previous');
		entry.addClass('fellow-spend-entry-next');
	    } else {
		entry.removeClass('fellow-spend-entry-active');
		entry.removeClass('fellow-spend-entry-next');
		entry.addClass('fellow-spend-entry-previous');
	    }
	});
	update();
    });


    update();

})()
