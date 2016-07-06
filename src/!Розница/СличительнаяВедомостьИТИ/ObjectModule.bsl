﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем Идентификатор Экспорт;
Перем СтруктураМакета Экспорт;	 
Перем МассивНазначений Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

Функция ПечатьИНВ19(МассивОбъектов, ОбъектыПечати)
	
	КолонкаКодов = ФормированиеПечатныхФормСервер.ИмяДополнительнойКолонки();
	
	Если ПустаяСтрока(КолонкаКодов) Тогда
		
		КолонкаКодов = "Код";
		
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	Документ.Ссылка КАК Ссылка,
	                      |	Документ.Номер КАК Номер,
	                      |	Документ.Дата КАК Дата,
	                      |	Документ.Дата КАК ДатаДокумента,
	                      |	Документ.Дата КАК ДатаНачалаИнвентаризации,
	                      |	Документ.Организация КАК Организация,
	                      |	Документ.Организация КАК Руководители,
	                      |	Документ.Организация.Префикс КАК Префикс,
	                      |	ПРЕДСТАВЛЕНИЕ(Документ.Магазин) КАК ПредставлениеПодразделения,
	                      |	ПРЕДСТАВЛЕНИЕ(Документ.Склад) КАК СкладПредставление,
	                      |	ПРЕДСТАВЛЕНИЕ(Документ.Организация) КАК ОрганизацияПредставление
	                      |ИЗ
	                      |	Документ.ПересчетТоваров КАК Документ
	                      |ГДЕ
	                      |	Документ.Ссылка В(&МассивДокументов)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Ссылка
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВложенныйЗапрос.Ссылка КАК Ссылка,
	                      |	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	                      |	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.Номенклатура) КАК НоменклатураПредставление,
	                      |	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.Характеристика) КАК ХарактеристикаПредставление,
	                      |	ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК ТоварНаименование,
	                      |	ВложенныйЗапрос.Номенклатура.Код КАК ТоварКод,
	                      |	ВложенныйЗапрос.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияПредставление,
	                      |	ВложенныйЗапрос.ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКодПоОКЕИ,
	                      |	ВложенныйЗапрос.Характеристика КАК Характеристика,
	                      |	ВложенныйЗапрос.РезультатНедостачаКолво КАК РезультатНедостачаКолво,
	                      |	ВложенныйЗапрос.РезультатНедостачаСумма КАК РезультатНедостачаСумма,
	                      |	ВложенныйЗапрос.РезультатИзлишекКолво КАК РезультатИзлишекКолво,
	                      |	ВложенныйЗапрос.РезультатИзлишекСумма КАК РезультатИзлишекСумма,
	                      |	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки
	                      |ИЗ
	                      |	(ВЫБРАТЬ
	                      |		Документ.Ссылка КАК Ссылка,
	                      |		Документ.Номенклатура КАК Номенклатура,
	                      |		ВЫБОР
	                      |			КОГДА Документ.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
	                      |				ТОГДА Документ.Номенклатура.ЕдиницаИзмерения
	                      |			ИНАЧЕ Документ.Упаковка.ЕдиницаИзмерения
	                      |		КОНЕЦ КАК ЕдиницаИзмерения,
	                      |		Документ.Характеристика КАК Характеристика,
	                      |		Документ.НомерСтроки КАК НомерСтроки,
	                      |		ВЫБОР
	                      |			КОГДА Документ.КоличествоФакт - Документ.Количество < 0
	                      |					И Документ.СуммаФакт - Документ.Сумма < 0
	                      |				ТОГДА -(Документ.КоличествоФакт - Документ.Количество)
	                      |			КОГДА Документ.КоличествоФакт - Документ.Количество < 0
	                      |					И Документ.СуммаФакт - Документ.Сумма >= 0
	                      |				ТОГДА -(Документ.КоличествоФакт - Документ.Количество)
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ КАК РезультатНедостачаКолво,
	                      |		ВЫБОР
	                      |			КОГДА Документ.КоличествоФакт - Документ.Количество < 0
	                      |					И Документ.СуммаФакт - Документ.Сумма < 0
	                      |				ТОГДА -(Документ.СуммаФакт - Документ.Сумма)
	                      |			КОГДА Документ.КоличествоФакт - Документ.Количество < 0
	                      |					И Документ.СуммаФакт - Документ.Сумма >= 0
	                      |				ТОГДА Документ.СуммаФакт - Документ.Сумма
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ КАК РезультатНедостачаСумма,
	                      |		ВЫБОР
	                      |			КОГДА Документ.КоличествоФакт - Документ.Количество < 0
	                      |					И Документ.СуммаФакт - Документ.Сумма < 0
	                      |				ТОГДА 0
	                      |			КОГДА Документ.КоличествоФакт - Документ.Количество < 0
	                      |					И Документ.СуммаФакт - Документ.Сумма >= 0
	                      |				ТОГДА 0
	                      |			ИНАЧЕ Документ.КоличествоФакт - Документ.Количество
	                      |		КОНЕЦ КАК РезультатИзлишекКолво,
	                      |		ВЫБОР
	                      |			КОГДА Документ.КоличествоФакт - Документ.Количество < 0
	                      |					И Документ.СуммаФакт - Документ.Сумма < 0
	                      |				ТОГДА 0
	                      |			КОГДА Документ.КоличествоФакт - Документ.Количество < 0
	                      |					И Документ.СуммаФакт - Документ.Сумма >= 0
	                      |				ТОГДА 0
	                      |			ИНАЧЕ Документ.СуммаФакт - Документ.Сумма
	                      |		КОНЕЦ КАК РезультатИзлишекСумма
	                      |	ИЗ
	                      |		Документ.ПересчетТоваров.Товары КАК Документ
	                      |	ГДЕ
	                      |		Документ.Ссылка В(&МассивДокументов)
	                      |		И Документ.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	                      |		И Документ.КоличествоФакт - Документ.Количество <> 0) КАК ВложенныйЗапрос
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Ссылка,
	                      |	НомерСтроки
	                      |ИТОГИ ПО
	                      |	Ссылка");
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПересчетТоваров_ИНВ19";
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	// Зададим параметры макета
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ДанныеПечати      = МассивРезультатов[0].Выбрать();
	ВыборкаПоДокументам = МассивРезультатов[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	//KAV Добавочная информация о корректировках
	Запрос.Текст="ВЫБРАТЬ
	             |	ПересчетТоваров.Ссылка КАК ПересчетТоваров
	             |ПОМЕСТИТЬ ВТ_Документы
	             |ИЗ
	             |	Документ.ПересчетТоваров КАК ПересчетТоваров
	             |ГДЕ
	             |	ПересчетТоваров.Ссылка В(&МассивДокументов)
	             |
	             |ИНДЕКСИРОВАТЬ ПО
	             |	ПересчетТоваров
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ВТ_Документы.ПересчетТоваров.Ссылка КАК ПересчетТоваровСсылка,
	             |	ВТ_Документы.ПересчетТоваров.Магазин КАК Магазин,
	             |	ВТ_Документы.ПересчетТоваров.Организация КАК Организация,
	             |	ВТ_Документы.ПересчетТоваров.Склад КАК Склад,
	             |	ВТ_Документы.ПересчетТоваров.Дата КАК Дата,
	             |	МАКСИМУМ(ПредыдущиеПересчетыТоваров.Дата) КАК ДатаПредыдущейИнвентариации
	             |ПОМЕСТИТЬ ВТ_ДокументыСДатамиИнвентаризаций
	             |ИЗ
	             |	ВТ_Документы КАК ВТ_Документы
	             |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПересчетТоваров КАК ПредыдущиеПересчетыТоваров
	             |		ПО (ПредыдущиеПересчетыТоваров.Проведен)
	             |			И ВТ_Документы.ПересчетТоваров.Дата > ПредыдущиеПересчетыТоваров.Дата
	             |			И ВТ_Документы.ПересчетТоваров.Магазин = ПредыдущиеПересчетыТоваров.Магазин
	             |			И ВТ_Документы.ПересчетТоваров.Организация = ПредыдущиеПересчетыТоваров.Организация
	             |			И ВТ_Документы.ПересчетТоваров.Склад = ПредыдущиеПересчетыТоваров.Склад
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	ВТ_Документы.ПересчетТоваров.Ссылка,
	             |	ВТ_Документы.ПересчетТоваров.Магазин,
	             |	ВТ_Документы.ПересчетТоваров.Организация,
	             |	ВТ_Документы.ПересчетТоваров.Склад,
	             |	ВТ_Документы.ПересчетТоваров.Дата
	             |
	             |ИНДЕКСИРОВАТЬ ПО
	             |	ПересчетТоваровСсылка,
	             |	Магазин,
	             |	Организация,
	             |	Склад,
	             |	Дата,
	             |	ДатаПредыдущейИнвентариации
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ВТ_ДокументыСДатамиИнвентаризаций.ПересчетТоваровСсылка КАК ПересчетТоваровСсылка,
	             |	ОприходованиеТоваровТовары.Номенклатура КАК Номенклатура,
	             |	ОприходованиеТоваровТовары.Характеристика,
	             |	СУММА(ОприходованиеТоваровТовары.Количество) КАК Количество,
	             |	ВЫБОР
	             |		КОГДА ОприходованиеТоваровТовары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
	             |			ТОГДА ОприходованиеТоваровТовары.Номенклатура.ЕдиницаИзмерения
	             |		ИНАЧЕ ОприходованиеТоваровТовары.Упаковка.ЕдиницаИзмерения
	             |	КОНЕЦ КАК ЕдиницаИзмерения,
	             |	ОприходованиеТоваров.Номер КАК Номер,
	             |	ОприходованиеТоваров.Дата,
	             |	СУММА(1) КАК Сумма
	             |ИЗ
	             |	ВТ_ДокументыСДатамиИнвентаризаций КАК ВТ_ДокументыСДатамиИнвентаризаций
	             |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОприходованиеТоваров.Товары КАК ОприходованиеТоваровТовары
	             |			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОприходованиеТоваров КАК ОприходованиеТоваров
	             |			ПО ОприходованиеТоваровТовары.Ссылка = ОприходованиеТоваров.Ссылка
	             |		ПО (ОприходованиеТоваров.Дата >= ВТ_ДокументыСДатамиИнвентаризаций.ДатаПредыдущейИнвентариации)
	             |			И (ОприходованиеТоваров.Дата <= ВТ_ДокументыСДатамиИнвентаризаций.Дата)
	             |			И (ОприходованиеТоваров.Магазин = ВТ_ДокументыСДатамиИнвентаризаций.Магазин)
	             |			И (ОприходованиеТоваров.Склад = ВТ_ДокументыСДатамиИнвентаризаций.Склад)
	             |			И (ОприходованиеТоваров.Организация = ВТ_ДокументыСДатамиИнвентаризаций.Организация)
	             |			И (ОприходованиеТоваров.Проведен)
	             |			И (ОприходованиеТоваров.АналитикаХозяйственнойОперации = &ОприходованияОтрицательныхОстатков)
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	ВТ_ДокументыСДатамиИнвентаризаций.ПересчетТоваровСсылка,
	             |	ОприходованиеТоваровТовары.Номенклатура,
	             |	ОприходованиеТоваров.Номер,
	             |	ОприходованиеТоваров.Дата,
	             |	ОприходованиеТоваровТовары.Характеристика,
	             |	ВЫБОР
	             |		КОГДА ОприходованиеТоваровТовары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка)
	             |			ТОГДА ОприходованиеТоваровТовары.Номенклатура.ЕдиницаИзмерения
	             |		ИНАЧЕ ОприходованиеТоваровТовары.Упаковка.ЕдиницаИзмерения
	             |	КОНЕЦ
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	ОприходованиеТоваров.Дата";
	Запрос.УстановитьПараметр("ОприходованияОтрицательныхОстатков", Справочники.ИТИКонстанты.АналитикаХозоперацииОприходованиеДляМинусовПоПродажам.Указатель);
	ТаблицаКорректировок = Запрос.Выполнить().Выгрузить();
	
	Макет = ПолучитьМакет("ПФ_MXL_ИНВ19");
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим общие реквизиты шапки.
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		
		СведенияОбОрганизации    = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ДанныеПечати.Организация,      ДанныеПечати.ДатаДокумента);
		
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ОбластьМакета.Параметры.НомерДокумента           = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(ДанныеПечати.Номер, Ложь, Истина);
		ОбластьМакета.Параметры.ПредставлениеОрганизации = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОбОрганизации);
		ОбластьМакета.Параметры.ОрганизацияПоОКПО        = СведенияОбОрганизации.КодПоОКПО;
				
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		НомерСтраницы = 2;
		
		ИтоговыеСуммы = Новый Структура;
		
		// Инициализация итогов по странице.
		
		ИтоговыеСуммы.Вставить("ИтогоРезультатНедостачаКолвоНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоРезультатНедостачаСуммаНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоРезультатИзлишекКолвоНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоРезультатИзлишекСуммаНаСтранице", 0);
		//KAV
		ИтоговыеСуммы.Вставить("ИтогоРегулировкаНедостачаКолвоНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоРегулировкаНедостачаСуммаНаСтранице", 0);
		
		// Инициализация итогов по документу.
		ИтоговыеСуммы.Вставить("ИтогоРезультатНедостачаКолво", 0);
		ИтоговыеСуммы.Вставить("ИтогоРезультатНедостачаСумма", 0);
		ИтоговыеСуммы.Вставить("ИтогоРезультатИзлишекКолво", 0);
		ИтоговыеСуммы.Вставить("ИтогоРезультатИзлишекСумма", 0);		
		//KAV
		ИтоговыеСуммы.Вставить("ИтогоРегулировкаНедостачаКолво", 0);
		ИтоговыеСуммы.Вставить("ИтогоРегулировкаНедостачаСумма", 0);
		
		ДанныеСтроки = Новый Структура;
		ДанныеСтроки.Вставить("Номер", 0);
		ДанныеСтроки.Вставить("РезультатНедостачаКолво", 0);
		ДанныеСтроки.Вставить("РезультатНедостачаСумма", 0);
		ДанныеСтроки.Вставить("РезультатИзлишекКолво", 0);
		ДанныеСтроки.Вставить("РезультатИзлишекСумма", 0);
		
		
		// Создаем массив для проверки вывода.
		МассивВыводимыхОбластей = Новый Массив;
		
		// Выводим многострочную часть документа.
		ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ОбластьМакета           = Макет.ПолучитьОбласть("СтрокаТаблицы");
		ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		ОбластьВсего            = Макет.ПолучитьОбласть("Всего");
		ОбластьПодвала          = Макет.ПолучитьОбласть("Подвал");
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска);
		
		КоличествоСтрок = ВыборкаПоДокументам.Количество();
		
		СтрокаТовары = ВыборкаПоДокументам.Выбрать();
		//Массив строк с корректировками
		Корректировки=ТаблицаКорректировок.НайтиСтроки(Новый Структура("ПересчетТоваров",ВыборкаПоДокументам.Ссылка));
		ЕстьКорректировки=(Корректировки.Количество()>0);
		
		Пока СтрокаТовары.Следующий() Цикл
			
			ДанныеСтроки.Номер = ДанныеСтроки.Номер + 1;
			
			ОбластьМакета.Параметры.Заполнить(СтрокаТовары);
			ОбластьМакета.Параметры.ТоварНаименование = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(
			СтрокаТовары.ТоварНаименование,
			СтрокаТовары.Характеристика);
			
			ДанныеСтроки.РезультатНедостачаКолво = СтрокаТовары.РезультатНедостачаКолво;
			ДанныеСтроки.РезультатНедостачаСумма = СтрокаТовары.РезультатНедостачаСумма;
			ДанныеСтроки.РезультатИзлишекКолво   = СтрокаТовары.РезультатИзлишекКолво;
			ДанныеСтроки.РезультатИзлишекСумма   = СтрокаТовары.РезультатИзлишекСумма;
			
			ОбластьМакета.Параметры.Заполнить(ДанныеСтроки);
			
			Если ДанныеСтроки.Номер = 1 Тогда // первая строка
				
				ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы; 
				ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
				
			Иначе
				
				МассивВыводимыхОбластей.Очистить();
				МассивВыводимыхОбластей.Добавить(ОбластьМакета);
				МассивВыводимыхОбластей.Добавить(ОбластьИтоговПоСтранице);
				
				Если ДанныеСтроки.Номер = КоличествоСтрок Тогда
					
					МассивВыводимыхОбластей.Добавить(ОбластьВсего);
					МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
					
				КонецЕсли;
				
				Если ДанныеСтроки.Номер <> 1 И Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
					
					ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
					
					ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
					
					// Очистим итоги по странице.
					ИтоговыеСуммы.ИтогоРезультатНедостачаКолвоНаСтранице = 0;
					ИтоговыеСуммы.ИтогоРезультатНедостачаСуммаНаСтранице = 0;
					ИтоговыеСуммы.ИтогоРезультатИзлишекКолвоНаСтранице   = 0;
					ИтоговыеСуммы.ИтогоРезультатИзлишекСуммаНаСтранице   = 0;
					
					
					НомерСтраницы = НомерСтраницы + 1;
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы;
					ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
					
				КонецЕсли;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// Увеличим итоги по странице.
			
			ИтоговыеСуммы.ИтогоРезультатНедостачаКолвоНаСтранице = ИтоговыеСуммы.ИтогоРезультатНедостачаКолвоНаСтранице + ДанныеСтроки.РезультатНедостачаКолво;
			ИтоговыеСуммы.ИтогоРезультатНедостачаСуммаНаСтранице = ИтоговыеСуммы.ИтогоРезультатНедостачаСуммаНаСтранице + ДанныеСтроки.РезультатНедостачаСумма;
			ИтоговыеСуммы.ИтогоРезультатИзлишекКолвоНаСтранице   = ИтоговыеСуммы.ИтогоРезультатИзлишекКолвоНаСтранице   + ДанныеСтроки.РезультатИзлишекКолво;
			ИтоговыеСуммы.ИтогоРезультатИзлишекСуммаНаСтранице   = ИтоговыеСуммы.ИтогоРезультатИзлишекСуммаНаСтранице   + ДанныеСтроки.РезультатИзлишекСумма;
			
			// Увеличим итоги по документу.
			
			ИтоговыеСуммы.ИтогоРезультатНедостачаКолво  = ИтоговыеСуммы.ИтогоРезультатНедостачаКолво + ДанныеСтроки.РезультатНедостачаКолво;
			ИтоговыеСуммы.ИтогоРезультатНедостачаСумма  = ИтоговыеСуммы.ИтогоРезультатНедостачаСумма + ДанныеСтроки.РезультатНедостачаСумма;
			ИтоговыеСуммы.ИтогоРезультатИзлишекКолво    = ИтоговыеСуммы.ИтогоРезультатИзлишекКолво   + ДанныеСтроки.РезультатИзлишекКолво;
			ИтоговыеСуммы.ИтогоРезультатИзлишекСумма    = ИтоговыеСуммы.ИтогоРезультатИзлишекСумма   + ДанныеСтроки.РезультатИзлишекСумма;
			
		КонецЦикла;
		
		Если ДанныеСтроки.Номер = 0 Тогда // шапка не выводилась
			
			ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы; 
			ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
			
		КонецЕсли;
		
		
		// Выводим итоги по последней странице.
		ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
		
		ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
		
		// Выводим итоги по документу в целом.
		
		ОбластьВсего.Параметры.Заполнить(ИтоговыеСуммы);
		
		ТабличныйДокумент.Вывести(ОбластьВсего);
		
		// Выводим подвал документа
		ОбластьПодвала.Параметры.Заполнить(ДанныеПечати);
		
		Руководители = ФормированиеПечатныхФормСервер.ОтветственныеЛицаОрганизаций(ДанныеПечати.Руководители, ДанныеПечати.Дата);
		ОбластьПодвала.Параметры.ФИОБухгалтера       = ФормированиеПечатныхФормСервер.ФамилияИнициалыФизЛица(Руководители.ГлавныйБухгалтер);
		
		ТабличныйДокумент.Вывести(ОбластьПодвала);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, СтруктураМакета.Идентификатор) Тогда
		ПодготовленныйТабДок = ПечатьИНВ19(МассивОбъектов, ОбъектыПечати);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, СтруктураМакета.Идентификатор, СтруктураМакета.Представление, ПодготовленныйТабДок);
	КонецЕсли;
	
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ПодготовленныйТабДок;
	
КонецПроцедуры

//ПЕРЕНЕСТИ В НОВЫЙ МАКЕТ
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("1.0.0.0");
	
	СписокОбъектов = "";
	Для Каждого Строка Из СтруктураМакета.ТипДокумента Цикл  
		СписокОбъектов = СписокОбъектов + ?(СписокОбъектов = "", Строка, ", " + Строка);
	КонецЦикла;
	
	ПараметрыРегистрации.Вид 			 = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиПечатнаяФорма();
	ПараметрыРегистрации.Версия 		 = ЭтотОбъект.Метаданные().Комментарий; //Версия печатной формы, можно устанавливать в ручную
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	ПараметрыРегистрации.Назначение      = СтруктураМакета.ТипДокумента;
    ПараметрыРегистрации.Наименование	 = "Внешняя печатная форма: " + СтруктураМакета.Представление;
	ПараметрыРегистрации.Информация		 = СписокОбъектов;        			    //Перечисление объектов для печати
	
	НоваяКоманда 						 = ПараметрыРегистрации.Команды.Добавить();
	НоваяКоманда.Представление 			 = НСтр("ru = '" + СтруктураМакета.Представление + " " + СтруктураМакета.ПрефиксВПФ + "'");
	НоваяКоманда.Идентификатор 			 = СтруктураМакета.Идентификатор;
	НоваяКоманда.Использование 			 = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	НоваяКоманда.ПоказыватьОповещение 	 = Истина;
	НоваяКоманда.Модификатор 			 = "ПечатьMXL";
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Идентификатор	= "ИНВ19"; 						 //Идентификатор внешней печатной формы (М11)
Представление   = "Сличительная ведемость(за межинвентаризационный период)"; //Имя команды в интерфейсе (M-11 (Требование-накладная))
ПрефиксВПФ 	 	= ""; 				 	 //Префикс добавляемый к имени команды интерфейса, для отделения от встроенных команд (ХХХХХХХ)

СтруктураМакета = Новый Структура("ТипДокумента, Идентификатор, Представление, ПрефиксВПФ");

МассивНазначений = Новый Массив; //Массив объектов метаданных, для которых будут определены печатная форма
МассивНазначений.Добавить("Документ.ПересчетТоваров");

СтруктураМакета.ТипДокумента  = МассивНазначений;
СтруктураМакета.Идентификатор = Идентификатор;
СтруктураМакета.Представление = Представление; 
СтруктураМакета.ПрефиксВПФ    = ПрефиксВПФ;

ПараметрыВывода 	  = УправлениеПечатью.ПодготовитьСтруктуруПараметровВывода();

 #КонецЕсли

