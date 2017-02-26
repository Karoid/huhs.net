/************************
made by Karoid
*************************
<table id="datatable_category">																		  #테이블은 id 값으로 아무이름_database table이름 으로 설정한다. _ 로 구분
	<thead>
		<tr>
			<th>
				<input type="checkbox" id="check-all" class="flat" disabled>
			</th>
			<th class="column-title">영문명 </th>
			<th class="column-title">한글명 </th>
			<th class="column-title">카테고리 명</th>
			<th class="column-title">리다이렉트 주소 </th>
			<th class="column-title no-link last"><span class="nobr">Action</span>
			</th>
		</tr>
	</thead>

	<tbody>
		<% @category.each do |category|%>
		<tr class="even pointer">
			<td class="a-center " name="id">                                # a-center라는 클래스를 가져야 함, name 값을 잊어먹지 말아야함
				<input type="checkbox" class="flat" name="table_records" id="<%=category.id%>">  #id 값에 databasetable의 id값을 넣어놓는다
			</td>
			<td class=" " name="route"><%=category.route%></td>              #반드시 name의 값으로 테이블의 tuple의 값으로 넣어야 한다.
			<td class=" " name="name"><%=category.name%></td>
			<td class=" " name="category.name"><%=board.category.name%></td> #테이블이 속해 있는 경우! 그 상위 테이블(여기서는 category)가 그 페이지 안에 있으면 edit 버튼을 누르면 option input을 쓸 수 있다.
			<td class=" " name="default"><%=category.default%></i></td>
			<td class=" last"><a href="#" class="edit_category">Edit</a>
			</td>
		</tr>
		<%end%>
	</tbody>
</table>
************************/
function Admin_table(element, dbname){
	this.tableElement = element
	this.dbname = dbname
	this.selectedArray = [];
	this.edit_ajax = function(send_data,success_cb){
		$.ajax({
			statusCode: {
	      500: function() {
	        alert("오타 때문에 수정 실패");
				},
				404: function(){
					alert("서버와의 통신 실패")
				}
	    },
			url: '/admin/edit_data',
			type: 'POST',
			dataType: 'json',
			data: send_data,
			success: function(data){
				success_cb(data)
			}
		})
	}
}
Admin_table.prototype.destroy = function(element,ajaxUrl) {
	var table = this.tableElement
	this.selectedArray = []
	var selectedArray = this.selectedArray
	var dbname = this.dbname
	$(table).find(element).each(function(index, el) {
		if (el.checked) {
			selectedArray.push(el.id)
		}
	});
	if (selectedArray.length && confirm(selectedArray.length + "개의 데이터를 선택하시겠습니까?")) {
		$.ajax({
			statusCode: {
				500: function() {
					alert("형식을 맞추지 않아 실패");
				},
				404: function(){
					alert("서버와의 통신 실패")
				}
			},
			url: ajaxUrl,
			method: "post",
			dataType: "json",
			data: {data: selectedArray, db: dbname},
			success: function(data){
				if (data.notice = "success") {
					location.reload();
				}else {
					alert("실패")
				}
			}
		})
	}else if(selectedArray.length == 0){
		alert("데이터를 선택하세요")
	}
};
Admin_table.prototype.delete = function(checkboxClassName) {
	this.destroy(checkboxClassName,'/admin/delete_data')
};
Admin_table.prototype.inactive = function(checkboxClassName) {
	this.destroy(checkboxClassName,'/admin/inactive_data')
};
Admin_table.prototype.active = function(checkboxClassName) {
	this.destroy(checkboxClassName,'/admin/active_data')
};
Admin_table.prototype.edit = function(editButton, thisClass){
	thisClass = thisClass || this
	var table = thisClass.tableElement
	var dbname = thisClass.dbname
	$(table).find(editButton).click(edit_event);

	function edit_event() {
		$(this).parents("tr").children().each(function(index, el) {
			if (!el.classList.length && el.getAttribute("name")) {
				var content = el.innerHTML
				if (content == "true") {
					el.innerHTML = "<input class='edit_input' type='checkbox' checked='"+content+"'>"
				}else if (content == "false"){
					el.innerHTML = "<input class='edit_input' type='checkbox'>"
				}else if ($.isNumeric(content)) {
					el.innerHTML = "<input class='edit_input' type='number' value='"+content+"'>"
				}else {
					el.innerHTML = "<input class='edit_input' type='text' value='"+content+"'>"
				}
			}else if($(el).hasClass('last')){
				var id = ""
				if (table[0] == "#") {
					id = table;
				}
				el.innerHTML = "<a href='"+id+"' class='submit'>Submit</a>";
				$(el).find('.submit').click(submit_edit);
			}
		});
	}

	function submit_edit(){
		var selectedObject = {data: {}, db: dbname}
		var thisElement = $(this)
		thisElement.parents("tr").children().each(function(index, el) {
			if (!el.classList.length && el.getAttribute("name")) {
				var inputbox = el.getElementsByTagName("input")[0]
				if (inputbox.type != "checkbox") {
					selectedObject['data'][el.getAttribute("name")] = el.getElementsByTagName("input")[0].value
				}else{
					selectedObject['data'][el.getAttribute("name")] = el.getElementsByTagName("input")[0].checked
				}
			}else if($(el).hasClass("a-center")){
				selectedObject['data'][el.getAttribute("name")] = $(el).find("input").attr("id")
			}
		});
		thisClass.edit_ajax(selectedObject,function(data){
			if (data.notice = "success") {
				thisElement.parents("tr").find("input[type=checkbox]").attr("id",data.id)
				console.log(thisElement.parents("tr"));
				thisElement.parents("tr").children().each(function(index, el) {
					if (!el.classList.length && el.getAttribute("name")) {
						el.innerHTML = selectedObject['data'][el.getAttribute("name")]
					}else if($(el).hasClass('last')){
						var id = ""
						if (table[0] == "#") {
							id = table;
						}
						editButton = typeof editButton == "object" ? "."+editButton.className : editButton
						el.innerHTML = "<a href='"+id+"' class='"+editButton.split(".")[1]+"'>Edit</a>";
						$(el).find(editButton).click(edit_event);
					}
				});
			}else {
				alert("수정 실패")
			}
		})

	}
}
Admin_table.prototype.create = function(createButton) {
	var table = this.tableElement
	var edit = this.edit
	var thisClass = this
	$(createButton).click(function() {
		/* Act on the event */
		$(table).find("tbody").append($(table).find("tr").last()[0].outerHTML)
		var lastTr = $(table).find("tr").last()
		edit(lastTr.find("a")[0],thisClass)
		lastTr.find("ins").click(function(event) {
			lastTr.find(".a-center input").trigger('click')
			if (lastTr.find(".a-center input")[0].checked) {
				lastTr.addClass('selected').find(".icheckbox_flat-green").addClass('checked')
			}else{
				lastTr.removeClass('selected').find(".icheckbox_flat-green").removeClass('checked')
			}
		});
		lastTr.find(".a-center input").attr("id","")

		lastTr.find("a").trigger('click')
		lastTr.find("input").val("")
	})
};
