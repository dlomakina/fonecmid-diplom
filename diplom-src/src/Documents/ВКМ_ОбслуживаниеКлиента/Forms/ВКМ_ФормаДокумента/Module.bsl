#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ Отказ Тогда
		ПроверитьИзмененияВДокументе();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
    ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаСервере
Процедура ПроверитьИзмененияВДокументе()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВКМ_ОбслуживаниеКлиента.ВКМ_ВремяНачалаРабот,
		|	ВКМ_ОбслуживаниеКлиента.ВКМ_ВремяОкончанияРабот,
		|	ВКМ_ОбслуживаниеКлиента.ВКМ_ДатаПроведенияРабот,
		|	ВКМ_ОбслуживаниеКлиента.ВКМ_Специалист
		|ИЗ
		|	Документ.ВКМ_ОбслуживаниеКлиента КАК ВКМ_ОбслуживаниеКлиента
		|ГДЕ
		|	ВКМ_ОбслуживаниеКлиента.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда

		Если НЕ Выборка.ВКМ_ВремяНачалаРабот = Объект.ВКМ_ВремяНачалаРабот Тогда
			
			ТекстСообщения = СтрШаблон("изменен:%1-время начала работ установлено: %3, предыдущее значение %2", 
						Символы.ПС, 
						Выборка.ВКМ_ВремяНачалаРабот,
						Формат(Объект.ВКМ_ВремяНачалаРабот,"ДЛФ=T"));
		
		КонецЕсли; 
		
		Если НЕ Выборка.ВКМ_ВремяОкончанияРабот = Объект.ВКМ_ВремяОкончанияРабот Тогда
			
			ТекстСообщения = СтрШаблон("изменен:%1%2-время окончания работ установлено: %4, предыдущее значение %3", 
						ТекстСообщения,
						Символы.ПС, 
						Выборка.ВКМ_ВремяОкончанияРабот,
						Формат(Объект.ВКМ_ВремяОкончанияРабот,"ДЛФ=T"));
		
		КонецЕсли;
		
		Если НЕ Выборка.ВКМ_ДатаПроведенияРабот = Объект.ВКМ_ДатаПроведенияРабот Тогда
			
			ТекстСообщения = СтрШаблон("изменен:%1%2-дата проведения работ установлена: %4, предыдущее значение %3", 
						ТекстСообщения,
						Символы.ПС, 
						Выборка.ВКМ_ДатаПроведенияРабот,
						Формат(Объект.ВКМ_ДатаПроведенияРабот,"ДЛФ=T"));
		
		КонецЕсли;
		
		Если НЕ Выборка.ВКМ_Специалист = Объект.ВКМ_Специалист Тогда
			
			ТекстСообщения = СтрШаблон("изменен:%1%2-специалит установлен: %4, предыдущее значение %3", 
						ТекстСообщения,
						Символы.ПС, 
						Выборка.ВКМ_Специалист,
						Объект.ВКМ_Специалист);
		
		КонецЕсли;
			
	Иначе
		
		ТекстСообщения = СтрШаблон("создан:%1дата проведения работ - %2
									|%1время начала работ - %3
									|%1время окончания работ - %4
									|%1специалист - %5",
									Символы.ПС,
									Объект.ВКМ_ДатаПроведенияРабот,
									Формат(Объект.ВКМ_ВремяНачалаРабот,"ДЛФ=T"),
									Формат(Объект.ВКМ_ВремяОкончанияРабот,"ДЛФ=T"),
									Объект.ВКМ_Специалист);
	
	КонецЕсли;
	
	Если СтрДлина(ТекстСообщения) > 0 Тогда
			
		ПолныйТекстСообщения = СтрШаблон("Документ Обслуживание клиента %1 от %2 %3", 
										Объект.Номер, 
										Объект.Дата,
										ТекстСообщения);
										
		НовоеСообщение = Справочники.ВКМ_УведомленияТелеграмБоту.СоздатьЭлемент();
		НовоеСообщение.ВКМ_Текст = ПолныйТекстСообщения;
		НовоеСообщение.Записать();
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти