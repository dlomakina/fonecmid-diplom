#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьТабличнуюЧасть(Команда)

	СоздатьРеализацию = Ложь;
	
	ДлительнаяОперация = НачатьВыполнениеНаСервере(СоздатьРеализацию);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОповещениеОЗавершении", ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры
&НаКлиенте
Процедура СоздатьДокументРеализации(Команда)

	СоздатьРеализацию = Истина;

	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.Интервал = 1;
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;

	ДлительнаяОперация = НачатьВыполнениеНаСервере(СоздатьРеализацию);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОповещениеОЗавершении", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция НачатьВыполнениеНаСервере(СоздатьРеализацию)
	
	Возврат ДлительныеОперации.ВыполнитьФункцию(УникальныйИдентификатор,
			"Обработки.ВКМ_МассовоеСозданиеАктов.СозданиеСпискаНаСервере", 
			Объект.ВКМ_Период, СоздатьРеализацию);

КонецФункции

&НаКлиенте
Процедура ОповещениеОЗавершении(Результат, ДополнительныеПараметры) Экспорт

	Если Результат.Статус = "Выполнено" Тогда
		
		МассивРеализаций = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		ЗаполнитьДоговоры(МассивРеализаций);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДоговоры(МассивРеализаций)

	Объект.ВКМ_СписокДоговоров.Очистить();

	Для Каждого Документ Из МассивРеализаций Цикл
		
		НоваяСтрока = Объект.ВКМ_СписокДоговоров.Добавить();
		НоваяСтрока.ВКМ_Договор = Документ.Договор;
		НоваяСтрока.ВКМ_РеализацияТоваровИУслуг = Документ.Реализация;
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти