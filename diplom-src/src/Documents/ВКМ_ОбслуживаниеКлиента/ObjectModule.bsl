#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ,Режим)

	// регистр ВКМ_ВыполненныеКлиентуРаботы
	Движения.ВКМ_ВыполненныеКлиентуРаботы.Записывать = Истина;

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.ВКМ_СтоимостьЧасаРаботы КАК Ставка,
		|	ДоговорыКонтрагентов.ВКМ_ДатаНачалаДействия КАК ДатаНачала,
		|	ДоговорыКонтрагентов.ВКМ_ДатаОкончанияДействия КАК ДатаОкончания,
		|	ДоговорыКонтрагентов.ВидДоговора КАК ВидДоговора,
		|	ДоговорыКонтрагентов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	ДоговорыКонтрагентов.Ссылка = &Договор";
	
	Запрос.УстановитьПараметр("Договор", ВКМ_Договор);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда

		Если НЕ (Дата >= Выборка.ДатаНачала И Дата <= Выборка.ДатаОкончания 
				И ВКМ_Договор = Выборка.Ссылка) Тогда
					
			ТекстСообщения = "Проведение документа невозможно.
			|Проверьте тип договора и дату документа: должна входить в период действия договора.";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			
		КонецЕсли;
		
		Ставка = Выборка.Ставка;

	КонецЕсли;
	
	Если Отказ = Ложь Тогда
		
		Для Каждого ТекСтрокаРаботы Из ВКМ_ВыполненныеРаботы Цикл
			
			Движение = Движения.ВКМ_ВыполненныеКлиентуРаботы.Добавить();
			Движение.Период = Дата;
			Движение.ВКМ_Клиент = ВКМ_Клиент;
			Движение.ВКМ_Договор = ВКМ_Договор;
			Движение.ВКМ_КоличествоЧасов = ТекСтрокаРаботы.ЧасыКОплатеКлиенту;
			Движение.ВКМ_СуммаКОплате = ТекСтрокаРаботы.ЧасыКОплатеКлиенту * Ставка;
			
		КонецЦикла;
		
	КонецЕсли;
	
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	//Данный фрагмент построен конструктором.
	//При повторном использовании конструктора, внесенные вручную данные будут утеряны!
	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

