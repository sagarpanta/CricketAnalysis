$(document).ready(function(){
	var pie;
	Raphael.fn.pieChart = function (cx, cy, r, values, labels, stroke) {
		var paper = this,
			rad = Math.PI / 180,
			chart = this.set();
		function sector(cx, cy, r, startAngle, endAngle, params) {
			var x1 = cx + r * Math.cos(-startAngle * rad),
				x2 = cx + r * Math.cos(-endAngle * rad),
				y1 = cy + r * Math.sin(-startAngle * rad),
				y2 = cy + r * Math.sin(-endAngle * rad);
			return paper.path(["M", cx, cy, "L", x1, y1, "A", r, r, 0, +(endAngle - startAngle > 180), 0, x2, y2, "z"]).attr(params);
		}
		var angle = 0,
			total = 0,
			start = 0,
			process = function (j) {
				var value = values[j],
					angleplus = 360 * value / total,
					popangle = angle + (angleplus / 2),
					color = Raphael.hsb(start, .4, .5),
					ms = 500,
					delta = 30,
					bcolor = Raphael.hsb(start, 1, 1),
					p = sector(cx, cy, r, angle, angle + angleplus, {fill: "90-" + bcolor + "-" + color, stroke: stroke, "stroke-width": 3}),
					txt = paper.text(cx + (r + delta + 55) * Math.cos(-popangle * rad), cy + (r + delta + 25) * Math.sin(-popangle * rad), labels[j]).attr({fill: bcolor, stroke: "none", opacity: 0, "font-size": 20});
				p.mouseover(function () {
					p.stop().animate({transform: "s1.1 1.1 " + cx + " " + cy}, ms, "elastic");
					txt.stop().animate({opacity: 1}, ms, "elastic");
				}).mouseout(function () {
					p.stop().animate({transform: ""}, ms, "elastic");
					txt.stop().animate({opacity: 0}, ms);
				}).click(function(){
					$('#directionkey').html(labels[j]);
				});;
				angle += angleplus;
				chart.push(p);
				chart.push(txt);
				start += .1;
			};
		for (var i = 0, ii = values.length; i < ii; i++) {
			total += values[i];
		}
		for (i = 0; i < ii; i++) {
			process(i);
		}
		return chart;
	};
	
	$('#runs a,#wides a,#noballs,#legbyes a ').on('click', function(){
		pie.remove();
		pie = Raphael("holder", 400, 400);
		Raphael("holder").remove();
		var values = [],
			labels = [];
		$("#direction tbody tr").each(function () {
			var td_val = parseInt($(this).children('td').text());
			var th_val = $(this).children('th').text();
			values.push(parseInt(td_val, 10));
			labels.push(th_val);
		});
		$("#direction").hide();
		var width = $(window).width();
		var height = $(window).height();
		var pos = $("#holder").position();
		var pos_of_shot = $('.dialog_td3').position();
		
		pie.pieChart(200,200, 60, values, labels, "#fff");
		$('#holder').offset({ top: pos_of_shot.top+80, left: width/2-200});			
	
	});
	
	var id_in_scorecard= $('#id').html(); 
	if(id_in_scorecard != undefined){
		pie = Raphael("holder", 400, 400);
		var values = [],
			labels = [];
		$("#direction tbody tr").each(function () {
			var td_val = parseInt($(this).children('td').text());
			var th_val = $(this).children('th').text();
			values.push(parseInt(td_val, 10));
			labels.push(th_val);
		});
		$("#direction").hide();
		var width = $(window).width();
		var height = $(window).height();
		var pos = $("#holder").position();
		var pos_of_shot = $('.dialog_td3').position();
		pie.pieChart(200,200, 60, values, labels, "#fff");
		$('#holder').offset({ top: pos_of_shot.top+80, left: width/2-200});	
	}
		

});