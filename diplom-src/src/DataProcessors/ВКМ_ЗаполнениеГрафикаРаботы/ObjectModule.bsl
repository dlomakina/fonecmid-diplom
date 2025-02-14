#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции	

Процедура ВКМ_ЗаполнитьГрафик(ДатаНачала, ДатаОкончания, ВыходныеДни) Экспорт 
	
	Набор = РегистрыСведений.ВКМ_ГрафикиРаботы.СоздатьНаборЗаписей();
	Набор.Отбор.ВКМ_ГрафикРаботы.Установить(ВКМ_ГрафикРаботы);
	Набор.Прочитать();
	
	ЧислоСекундВСутках = 86400;
	Дат = ДатаНачала;
	
	Для к = 0 По Набор.Количество()-1 Цикл
		
		Запись = Набор[к];
		
		Если Запись.ВКМ_Дата < ДатаНачала Тогда
		    Продолжить;
		ИначеЕсли Запись.ВКМ_Дата =Дат Тогда
			Если Найти(ВыходныеДни, Строка(ДеньНедели(Дат))) Тогда
				Запись.ВКМ_Значение = 0;
			Иначе	          
				Запись.ВКМ_Значение = 8;
			КонецЕсли;
			Дат = Дат + ЧислоСекундВСутках;
		Иначе
			Пока Дат < Мин(Запись.ВКМ_Дата, ДатаОкончания) Цикл
				НоваяЗапись = Набор.Добавить();
				НоваяЗапись.ВКМ_ГрафикРаботы = ВКМ_ГрафикРаботы;
				НоваяЗапись.ВКМ_Дата = Дат;
				Если Найти(ВыходныеДни, Строка(ДеньНедели(Дат))) Тогда
					НоваяЗапись.ВКМ_Значение = 0;
				Иначе	          
					НоваяЗапись.ВКМ_Значение = 8;
				КонецЕсли; 
				Дат = Дат + ЧислоСекундВСутках;
			КонецЦикла; 
			Если Запись.ВКМ_Дата > ДатаОкончания Тогда
				Прервать;
			Иначе
				Если Найти(ВыходныеДни, Строка(ДеньНедели(Дат))) Тогда
					Запись.ВКМ_Значение = 0;
				Иначе	          
					Запись.ВКМ_Значение = 8;
				КонецЕсли;
			КонецЕсли;
			Дат = Дат + ЧислоСекундВСутках;
		КонецЕсли; 
		
	КонецЦикла;
	
	Набор.Записать();
	
	Пока Дат <= ДатаОкончания Цикл
		Запись = Набор.Добавить();
		Запись.ВКМ_ГрафикРаботы = ВКМ_ГрафикРаботы;
		Запись.ВКМ_Дата = Дат;
		Если Найти(ВыходныеДни, Строка(ДеньНедели(Дат))) Тогда
			Запись.ВКМ_Значение = 0;
		Иначе	          
			Запись.ВКМ_Значение = 8;
		КонецЕсли; 
		Дат = Дат + ЧислоСекундВСутках;
	КонецЦикла; 
	
	Набор.Записать();
	
КонецПроцедуры

#КонецОбласти
#КонецЕсли
