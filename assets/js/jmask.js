$(document).ready(function(){
	console.log("Matt, funcionou!");
	
	$("input").focus(function(){
		$('.data_br').mask('99/99/9999');
		$('.shortdate').mask('99/9999');
		$('.time').mask('99:99:99');
		$('.cep').mask('99999999');
		$('.tel').mask("(99) 9999-9999?9").focusout(function (event) {  
            var target, phone, element;  
            target = (event.currentTarget) ? event.currentTarget : event.srcElement;  
            phone = target.value.replace(/\D/g, '');
            element = $(target);  
            element.unmask();  
            if(phone.length > 10) {  
                element.mask("(99) 99999-999?9");  
            } else {  
                element.mask("(99) 9999-9999?9");  
            }  
		});
        $('.telsm').mask('9999-9999');
		$('.cel').mask('(99)9 9999-9999');
		$('.cpf').mask('999.999.999-99');
		$('.cnpj').mask('99.999.999/9999-99');
		$('.iest').mask('999.999.999.999');
		$('.cnae').mask('9999999');
		$('.cpr').mask('9999');

	});
});