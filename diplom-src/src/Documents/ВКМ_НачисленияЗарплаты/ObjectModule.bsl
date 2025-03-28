#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ВКМ_СформироватьДвижения();

	ВКМ_РассчитатьОклад();
	ВКМ_РассчитьтьОтпуск();
	ВКМ_РассчитатьУдержания();

	ВКМ_СформироватьДвиженияПоВзаиморасчетам();
	ВКМ_СформироватьДвиженияПоУчетуОтпусков();

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Для Каждого Строка Из ВКМ_Начисления Цикл
		
		Если Строка.ВКМ_ДатаНачала > Строка.ВКМ_ДатаОкончания Тогда
			ТекстСообщения = "Дата начала больше даты окончания (строка №%1)";
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ТекстСообщения, Строка.НомерСтроки));
			Отказ = Истина;
		КонецЕсли;

		Если Строка.ВКМ_ВидРасчета = ПланыВидовРасчета.ВКМ_ДополнительныеНачисления.ВКМ_ФиксированнаяПремия Тогда
			ТекстСообщения = "Премии начисляются отдельным документом, проверьте вид расчета в строке №%1";
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ТекстСообщения, Строка.НомерСтроки));
			Отказ = Истина;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВКМ_СформироватьДвижения()

	Движения.ВКМ_ОсновныеНачисления.Записывать = Истина;
	Движения.ВКМ_ДополнительныеНачисления.Записывать = Истина;
	Движения.ВКМ_Удержания.Записывать = Истина;

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_Сотрудник КАК ВКМ_Сотрудник,
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ВидРасчета КАК ВКМ_ВидРасчета,
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ДатаНачала КАК ВКМ_ДатаНачала,
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ДатаОкончания КАК ВКМ_ДатаОкончания,
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ГрафикРаботы КАК ВКМ_ГрафикРаботы
	|ПОМЕСТИТЬ ВТ_Документ
	|ИЗ
	|	Документ.ВКМ_НачисленияЗарплаты.ВКМ_Начисления КАК ВКМ_НачисленияЗарплатыВКМ_Начисления
	|ГДЕ
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_Сотрудник,
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ВидРасчета,
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ДатаНачала,
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ДатаОкончания,
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ГрафикРаботы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВКМ_ВыполненныеСотрудникомРаботыОбороты.ВКМ_Сотрудник КАК ВКМ_Сотрудник,
	|	ВКМ_ВыполненныеСотрудникомРаботыОбороты.ВКМ_СуммаКОплатеОборот КАК ВКМ_СуммаКОплатеОборот
	|ПОМЕСТИТЬ ВТ_ВыполненныеРаботы
	|ИЗ
	|	РегистрНакопления.ВКМ_ВыполненныеСотрудникомРаботы.Обороты(&ДатаНачала, &ДатаОкончания,,) КАК
	|		ВКМ_ВыполненныеСотрудникомРаботыОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВКМ_УсловияОплатыСотрудниковСрезПоследних.ВКМ_Сотрудник КАК ВКМ_Сотрудник,
	|	ВКМ_УсловияОплатыСотрудниковСрезПоследних.ВКМ_ПроцентОтРабот КАК ВКМ_ПроцентОтРабот
	|ПОМЕСТИТЬ ВТ_УсловияОплаты
	|ИЗ
	|	РегистрСведений.ВКМ_УсловияОплатыСотрудников.СрезПоследних(&Дата,) КАК ВКМ_УсловияОплатыСотрудниковСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Документ.ВКМ_Сотрудник КАК ВКМ_Сотрудник,
	|	ВТ_Документ.ВКМ_ВидРасчета КАК ВКМ_ВидРасчета,
	|	ВТ_Документ.ВКМ_ДатаНачала КАК ВКМ_ДатаНачала,
	|	ВТ_Документ.ВКМ_ДатаОкончания КАК ВКМ_ДатаОкончания,
	|	ВТ_Документ.ВКМ_ГрафикРаботы КАК ВКМ_ГрафикРаботы,
	|	ВТ_УсловияОплаты.ВКМ_ПроцентОтРабот КАК ВКМ_ПроцентОтРабот,
	|	ВТ_ВыполненныеРаботы.ВКМ_СуммаКОплатеОборот КАК ВКМ_СуммаКОплате
	|ИЗ
	|	ВТ_Документ КАК ВТ_Документ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВыполненныеРаботы КАК ВТ_ВыполненныеРаботы
	|		ПО ВТ_Документ.ВКМ_Сотрудник = ВТ_ВыполненныеРаботы.ВКМ_Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УсловияОплаты КАК ВТ_УсловияОплаты
	|		ПО ВТ_Документ.ВКМ_Сотрудник = ВТ_УсловияОплаты.ВКМ_Сотрудник";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(Дата));

	Результат = Запрос.Выполнить().Выбрать();

	Пока Результат.Следующий() Цикл

		Если ТипЗнч(Результат.ВКМ_ВидРасчета) = Тип("ПланВидовРасчетаСсылка.ВКМ_ОсновныеНачисления") Тогда

			Движение = Движения.ВКМ_ОсновныеНачисления.Добавить();
			Движение.ПериодРегистрации = НачалоМесяца(Дата);
			Движение.ПериодДействияНачало = Результат.ВКМ_ДатаНачала;
			Движение.ПериодДействияКонец = Результат.ВКМ_ДатаОкончания;
			Движение.ВидРасчета = Результат.ВКМ_ВидРасчета;
			Движение.ВКМ_Сотрудник = Результат.ВКМ_Сотрудник;
			Движение.ВКМ_ГрафикРаботы = Результат.ВКМ_ГрафикРаботы;

			Если Результат.ВКМ_ВидРасчета = ПланыВидовРасчета.ВКМ_ОсновныеНачисления.ВКМ_Отпуск Тогда
				Движение.БазовыйПериодНачало = НачалоМесяца(ДобавитьМесяц(Результат.ВКМ_ДатаНачала, -12));
				Движение.БазовыйПериодКонец = КонецМесяца(ДобавитьМесяц(Результат.ВКМ_ДатаОкончания, -1));
			КонецЕсли;
			
		КонецЕсли;

		Если ТипЗнч(Результат.ВКМ_ВидРасчета) = Тип("ПланВидовРасчетаСсылка.ВКМ_ДополнительныеНачисления") Тогда
			
			Движение = Движения.ВКМ_ДополнительныеНачисления.Добавить();
			Движение.ПериодРегистрации = НачалоМесяца(Дата);
			Движение.ВидРасчета = Результат.ВКМ_ВидРасчета;
			Движение.ВКМ_Сотрудник = Результат.ВКМ_Сотрудник;
			Движение.ВКМ_ПроцентПермии = Результат.ВКМ_ПроцентОтРабот;
			Движение.ВКМ_Результат = Результат.ВКМ_СуммаКОплате;
			
		КонецЕсли;

	КонецЦикла;

	ВКМ_СформироватьДвиженияУдержания();

	Движения.ВКМ_ОсновныеНачисления.Записать();

	Движения.ВКМ_ДополнительныеНачисления.Записать();

	Движения.ВКМ_Удержания.Записать();

КонецПроцедуры

Процедура ВКМ_СформироватьДвиженияУдержания()

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_Сотрудник
	|ИЗ
	|	Документ.ВКМ_НачисленияЗарплаты.ВКМ_Начисления КАК ВКМ_НачисленияЗарплатыВКМ_Начисления
	|ГДЕ
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_Сотрудник";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Результат = Запрос.Выполнить().Выбрать();

	Пока Результат.Следующий() Цикл
		Движение = Движения.ВКМ_Удержания.Добавить();
		Движение.ПериодРегистрации = Дата;
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.ВКМ_НДФЛ;
		Движение.ВКМ_Сотрудник = Результат.ВКМ_Сотрудник;
		Движение.БазовыйПериодНачало = НачалоМесяца(Дата);
		Движение.БазовыйПериодКонец = КонецМесяца(Дата);
	КонецЦикла;

КонецПроцедуры

Процедура ВКМ_РассчитатьОклад()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_ОсновныеНачисленияДанныеГрафика.НомерСтроки,
	|	ЕСТЬNULL(ВКМ_ОсновныеНачисленияДанныеГрафика.ВКМ_ЗначениеПериодДействия, 0) КАК План,
	|	ЕСТЬNULL(ВКМ_ОсновныеНачисленияДанныеГрафика.ВКМ_ЗначениеФактическийПериодДействия, 0) КАК Факт,
	|	ВКМ_УсловияОплатыСотрудниковСрезПоследних.ВКМ_Оклад КАК Оклад
	|ИЗ
	|	РегистрРасчета.ВКМ_ОсновныеНачисления.ДанныеГрафика(Регистратор = &Ссылка
	|	И ВидРасчета = &ВидРасчета) КАК ВКМ_ОсновныеНачисленияДанныеГрафика
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВКМ_УсловияОплатыСотрудников.СрезПоследних(&Период, ВКМ_Сотрудник В
	|			(ВЫБРАТЬ
	|				ВКМ_ОсновныеНачисления.ВКМ_Сотрудник КАК Сотрудник
	|			ИЗ
	|				РегистрРасчета.ВКМ_ОсновныеНачисления КАК ВКМ_ОсновныеНачисления
	|			ГДЕ
	|				ВКМ_ОсновныеНачисления.Регистратор = &Ссылка
	|				И ВКМ_ОсновныеНачисления.ВидРасчета = &ВидРасчета)) КАК ВКМ_УсловияОплатыСотрудниковСрезПоследних
	|		ПО ВКМ_ОсновныеНачисленияДанныеГрафика.ВКМ_Сотрудник = ВКМ_УсловияОплатыСотрудниковСрезПоследних.ВКМ_Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидРасчета", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.ВКМ_Оклад);
	Запрос.УстановитьПараметр("Период", Дата);

	Результат = Запрос.Выполнить().Выбрать();

	Пока Результат.Следующий() Цикл

		Если Результат.План = 0 Тогда
			ОбщегоНазначения.СообщитьПользователю("Не заполнен график работы");
			Прервать;
		КонецЕсли;

		Движение = Движения.ВКМ_ОсновныеНачисления[Результат.НомерСтроки - 1];
		Движение.ВКМ_Результат = Результат.Оклад * Результат.Факт / Результат.План;
		Движение.ВКМ_ОтработаноЧасов = Результат.Факт;

	КонецЦикла;

	Движения.ВКМ_ОсновныеНачисления.Записать( , Истина);

КонецПроцедуры

Процедура ВКМ_РассчитьтьОтпуск()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	ВКМ_ОсновныеНачисления.НомерСтроки,
				   |	ЕСТЬNULL(ВКМ_ОсновныеНачисленияБазаВКМ_ДополнительныеНачисления.ВКМ_РезультатБаза, 0) КАК ДопРезультатБаза,
				   |	ЕСТЬNULL(ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.ВКМ_РезультатБаза, 0) КАК ОснРезультатБаза,
				   |	ЕСТЬNULL(ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.ВКМ_ОтработаноЧасовБаза, 0) КАК ОтработаноЧасовБаза,
				   |	ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.ПериодДействияНачало,
				   |	ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.ПериодДействияКонец
				   |ИЗ
				   |	РегистрРасчета.ВКМ_ОсновныеНачисления КАК ВКМ_ОсновныеНачисления
				   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ОсновныеНачисления.БазаВКМ_ДополнительныеНачисления(&Измерения, &Измерения,,
				   |			Регистратор = &Ссылка
				   |		И ВидРасчета = &Отпуск) КАК ВКМ_ОсновныеНачисленияБазаВКМ_ДополнительныеНачисления
				   |		ПО ВКМ_ОсновныеНачисления.НомерСтроки = ВКМ_ОсновныеНачисленияБазаВКМ_ДополнительныеНачисления.НомерСтроки
				   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ОсновныеНачисления.БазаВКМ_ОсновныеНачисления(&Измерения, &Измерения,,
				   |			Регистратор = &Ссылка
				   |		И ВидРасчета = &Отпуск) КАК ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления
				   |		ПО ВКМ_ОсновныеНачисления.НомерСтроки = ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.НомерСтроки
				   |ГДЕ
				   |	ВКМ_ОсновныеНачисления.ВидРасчета = &Отпуск
				   |	И ВКМ_ОсновныеНачисления.Регистратор = &Ссылка";

	Измерения = Новый Массив;
	Измерения.Добавить("ВКМ_Сотрудник");

	Запрос.УстановитьПараметр("Отпуск", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.ВКМ_Отпуск);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Измерения", Измерения);

	Результат = Запрос.Выполнить().Выбрать();

	Пока Результат.Следующий() Цикл

		Движение = Движения.ВКМ_ОсновныеНачисления[Результат.НомерСтроки - 1];

		ДнейОтработано = Результат.ОтработаноЧасовБаза / 8;
		ДнейОтпуска = (НачалоДня(Результат.ПериодДействияКонец) - НачалоДня(Результат.ПериодДействияНачало)) / (60 * 60
			* 24);
		Движение.ВКМ_Результат = (Результат.ОснРезультатБаза + Результат.ДопРезультатБаза) / ДнейОтработано
			* ДнейОтпуска;

	КонецЦикла;

	Движения.ВКМ_ОсновныеНачисления.Записать( , Истина);

КонецПроцедуры

Процедура ВКМ_РассчитатьУдержания()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	ВКМ_Удержания.НомерСтроки,
				   |	ВКМ_УдержанияБазаВКМ_ОсновныеНачисления.ВКМ_РезультатБаза КАК ОснРезультатБаза
				   |ПОМЕСТИТЬ ВТ_ОснУдерж
				   |ИЗ
				   |	РегистрРасчета.ВКМ_Удержания КАК ВКМ_Удержания
				   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_Удержания.БазаВКМ_ОсновныеНачисления(&Измерения, &Измерения, &Разрезы,
				   |			Регистратор = &Регистратор
				   |		И ВидРасчета = &ВидРасчета) КАК ВКМ_УдержанияБазаВКМ_ОсновныеНачисления
				   |		ПО ВКМ_Удержания.НомерСтроки = ВКМ_УдержанияБазаВКМ_ОсновныеНачисления.НомерСтроки
				   |ГДЕ
				   |	ВКМ_Удержания.Регистратор = &Регистратор
				   |	И ВКМ_Удержания.ВидРасчета = &ВидРасчета
				   |	И ВКМ_УдержанияБазаВКМ_ОсновныеНачисления.РегистраторРазрез = &Регистратор
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ
				   |	ВКМ_Удержания.НомерСтроки,
				   |	ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.ВКМ_РезультатБаза КАК ДопРезультатБаза
				   |ПОМЕСТИТЬ ВТ_ДопУдерж
				   |ИЗ
				   |	РегистрРасчета.ВКМ_Удержания КАК ВКМ_Удержания
				   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_Удержания.БазаВКМ_ДополнительныеНачисления(&Измерения, &Измерения, &Разрезы,
				   |			Регистратор = &Регистратор
				   |		И ВидРасчета = &ВидРасчета) КАК ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления
				   |		ПО ВКМ_Удержания.НомерСтроки = ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.НомерСтроки
				   |ГДЕ
				   |	ВКМ_Удержания.Регистратор = &Регистратор
				   |	И ВКМ_Удержания.ВидРасчета = &ВидРасчета
				   |	И
				   |		ТИПЗНАЧЕНИЯ(ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.РегистраторРазрез) <> ТИП(Документ.ВКМ_НачислениеФиксПремий)
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ
				   |	ВТ_ОснУдерж.НомерСтроки,
				   |	ЕСТЬNULL(ВТ_ОснУдерж.ОснРезультатБаза, 0) КАК ОснРезультатБаза,
				   |	ЕСТЬNULL(ВТ_ДопУдерж.ДопРезультатБаза, 0) КАК ДопРезультатБаза
				   |ИЗ
				   |	ВТ_ОснУдерж КАК ВТ_ОснУдерж
				   |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДопУдерж КАК ВТ_ДопУдерж
				   |		ПО ВТ_ОснУдерж.НомерСтроки = ВТ_ДопУдерж.НомерСтроки";
	Измерения = Новый Массив;
	Измерения.Добавить("ВКМ_Сотрудник");

	Разрезы = Новый Массив;
	Разрезы.Добавить("Регистратор");

	Запрос.УстановитьПараметр("Измерения", Измерения);
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("ВидРасчета", ПланыВидовРасчета.ВКМ_Удержания.ВКМ_НДФЛ);
	Запрос.УстановитьПараметр("Разрезы", Разрезы);

	Результат = Запрос.Выполнить().Выбрать();

	Пока Результат.Следующий() Цикл

		Движение = Движения.ВКМ_Удержания[Результат.НомерСтроки - 1];
		Движение.ВКМ_Результат = (Результат.ОснРезультатБаза + Результат.ДопРезультатБаза) * 13 / 100;

	КонецЦикла;

	Движения.ВКМ_Удержания.Записать( , Истина);

КонецПроцедуры

Процедура ВКМ_СформироватьДвиженияПоВзаиморасчетам()

	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина;

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	ВКМ_ОсновныеНачисления.ВКМ_Сотрудник КАК ОснСотрудник,
				   |	СУММА(ВКМ_ОсновныеНачисления.ВКМ_Результат) КАК ОснРезультат,
				   |	ВКМ_ОсновныеНачисления.ВидРасчета КАК ВидРасчета
				   |ПОМЕСТИТЬ ВТ_ОснНач
				   |ИЗ
				   |	РегистрРасчета.ВКМ_ОсновныеНачисления КАК ВКМ_ОсновныеНачисления
				   |ГДЕ
				   |	ВКМ_ОсновныеНачисления.Регистратор = &Регистратор
				   |СГРУППИРОВАТЬ ПО
				   |	ВКМ_ОсновныеНачисления.ВКМ_Сотрудник,
				   |	ВКМ_ОсновныеНачисления.ВидРасчета
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ
				   |	ВКМ_ДополнительныеНачисления.ВКМ_Сотрудник КАК ДопСотрудник,
				   |	СУММА(ВКМ_ДополнительныеНачисления.ВКМ_Результат) КАК ДопРезультат,
				   |	ВКМ_ДополнительныеНачисления.ВидРасчета КАК ВидРасчета
				   |ПОМЕСТИТЬ ВТ_ДопНач
				   |ИЗ
				   |	РегистрРасчета.ВКМ_ДополнительныеНачисления КАК ВКМ_ДополнительныеНачисления
				   |ГДЕ
				   |	ВКМ_ДополнительныеНачисления.Регистратор = &Регистратор
				   |СГРУППИРОВАТЬ ПО
				   |	ВКМ_ДополнительныеНачисления.ВКМ_Сотрудник,
				   |	ВКМ_ДополнительныеНачисления.ВидРасчета
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ
				   |	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_Сотрудник КАК Сотрудник,
				   |	ВТ_ДопНач.ДопРезультат КАК ДопРезультат,
				   |	ВТ_ОснНач.ОснРезультат КАК ОснРезультат,
				   |	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ВидРасчета КАК ВидРасчета
				   |ИЗ
				   |	Документ.ВКМ_НачисленияЗарплаты.ВКМ_Начисления КАК ВКМ_НачисленияЗарплатыВКМ_Начисления
				   |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОснНач КАК ВТ_ОснНач
				   |		ПО (ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_Сотрудник = ВТ_ОснНач.ОснСотрудник
				   |		И ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ВидРасчета = ВТ_ОснНач.ВидРасчета)
				   |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДопНач КАК ВТ_ДопНач
				   |		ПО (ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_Сотрудник = ВТ_ДопНач.ДопСотрудник
				   |		И ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ВидРасчета = ВТ_ДопНач.ВидРасчета)
				   |ГДЕ
				   |	ВКМ_НачисленияЗарплатыВКМ_Начисления.Ссылка = &Регистратор";

	Запрос.УстановитьПараметр("Регистратор", Ссылка);

	Результат = Запрос.Выполнить().Выбрать();

	Пока Результат.Следующий() Цикл
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.ВКМ_Сотрудник = Результат.Сотрудник;
		Движение.ВКМ_ВидРасчета = Результат.ВидРасчета;
		Если Результат.ОснРезультат = Null Тогда
			Движение.ВКМ_Сумма = Результат.ДопРезультат * 87 / 100;
		Иначе
			Движение.ВКМ_Сумма = Результат.ОснРезультат * 87 / 100;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ВКМ_СформироватьДвиженияПоУчетуОтпусков() 

	Движения.ВКМ_УчетОтпусков.Записывать = Истина;
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_Сотрудник КАК Сотрудник,
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ДатаОкончания КАК ДатаОкончания,
	|	РАЗНОСТЬДАТ(ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ДатаНачала,
	|		ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ДатаОкончания, ДЕНЬ) + 1 КАК КоличествоДней
	|ИЗ
	|	Документ.ВКМ_НачисленияЗарплаты.ВКМ_Начисления КАК ВКМ_НачисленияЗарплатыВКМ_Начисления
	|ГДЕ
	|	ВКМ_НачисленияЗарплатыВКМ_Начисления.Ссылка = &Ссылка
	|	И ВКМ_НачисленияЗарплатыВКМ_Начисления.ВКМ_ВидРасчета = &ВидРасчета";
	
	Запрос.УстановитьПараметр("ВидРасчета", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.ВКМ_Отпуск);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		Движение = Движения.ВКМ_УчетОтпусков.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход; 
		Движение.Период = Результат.ДатаОкончания;
		Движение.ВКМ_Сотрудник = Результат.Сотрудник;
		Движение.ВКМ_Значение = Результат.КоличествоДней;
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли