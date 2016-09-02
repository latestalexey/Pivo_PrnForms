﻿Функция Печать(ИмяМакета = "", ПараметрыПечати = Неопределено)	Экспорт

	Если НЕ ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не СсылкаНаОбъект.Проведен Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат Ложь;
	КонецЕсли;
	
	ТабДокумент = ПечатьДокумента(СсылкаНаОбъект);
	
	//Определим параметры печати
	Если ПараметрыПечати <> Неопределено Тогда
		КоличествоЭкземпляров = 1;
		Если НЕ(ПараметрыПечати.Свойство("КоличествоЭкземпляров",КоличествоЭкземпляров)) Тогда
			КоличествоЭкземпляров = 1;			
		КонецЕсли;
		НаПринтер = Ложь;
		Если НЕ(ПараметрыПечати.Свойство("НаПринтер",НаПринтер)) Тогда
			НаПринтер = Ложь;			
		КонецЕсли;
	КонецЕсли;
	Если КоличествоЭкземпляров = Неопределено Тогда
		КоличествоЭкземпляров = 1;
	КонецЕсли;
	Если НаПринтер = Неопределено Тогда
		НаПринтер = Ложь;
	КонецЕсли;
	
	Возврат ТабДокумент;

КонецФункции // Печать()

Функция ПечатьДокумента(СсылкаНаДокумент)
#Область Инициализация
	МакетWord=ПолучитьМакет("Макет");
	MSWord=МакетWord.Получить();
	Попытка 
		Документ=MSWord.Application.Documents(1);
	Исключение
		Сообщить("Не удалость открыть печатную форму по причине "+ОписаниеОшибки(),СтатусСообщения.Важное); 
		Возврат Неопределено;
	КонецПопытки;
	
	Обработка=Справочники.ВнешниеОбработки.НайтиПоКоду("000000004").ХранилищеВнешнейОбработки.Получить();
	Путь=ПолучитьИмяВременногоФайла("epf");
	Обработка.Записать(Путь);
	ПолучениеДанных=ВнешниеОбработки.Создать(Путь);
#КонецОбласти

	ЗаменитьШаблон(Документ,"[ДатаДок]",Формат(СсылкаНаДокумент.Дата,"ДФ='dd MMMM yyyy ""г.""'"));
	ЗаменитьШаблон(Документ,"[НомерДок]",ОбщегоНазначенияЗК.ПолучитьНомерНаПечать(СсылкаНаДокумент));
	
	ДанныеОрганизации=ПолучениеДанных.ПолучитьДанныеПоОрганизации(СсылкаНаДокумент.Организация,СсылкаНаДокумент.Дата);
	Для Каждого Эл Из ДанныеОрганизации Цикл
		ЗаменитьШаблон(Документ,"["+Эл.Ключ+"]",Эл.Значение);
	КонецЦикла;
	ДанныеСотрудника=ПолучениеДанных.ПолучитьДанныеПоСотруднику(СсылкаНаДокумент.РаботникиОрганизации[0].Сотрудник,СсылкаНаДокумент.РаботникиОрганизации[0].ДатаПриема);
	Для Каждого Эл Из ДанныеСотрудника Цикл
		ЗаменитьШаблон(Документ,"["+Эл.Ключ+"]",Эл.Значение);
	КонецЦикла;
	ДанныеФизЛицаСотрудника=ПолучениеДанных.ПолучитьДанныеПоФизЛицу(СсылкаНаДокумент.РаботникиОрганизации[0].Сотрудник.ФизЛицо,СсылкаНаДокумент.РаботникиОрганизации[0].ДатаПриема);
	Для Каждого Эл Из ДанныеФизЛицаСотрудника Цикл
		ЗаменитьШаблон(Документ,"["+Эл.Ключ+"]",Эл.Значение);
	КонецЦикла;
	
#Область Открытие_документа
	MSWord.Application.Visible=1;
	MSWord.Application.ActiveWindow.Visible=1;
	Документ.Activate();
	Документ.Application.Activate();
#КонецОбласти
	Возврат Неопределено;
КонецФункции

Процедура ЗаменитьШаблон(ДокWord, Шаблон, Значение)
	Если ТипЗнч(Значение)<>Тип("Строка") Тогда
		Возврат;
	КонецЕсли;
	Если СтрДлина(Значение)>254 Тогда
		//Сложный вывод длинного поля
		ДлинаОбрезки=254-СтрДлина(Шаблон);
		ВыводимоеЗначение=Значение;
		Обрезь=лев(ВыводимоеЗначение,ДлинаОбрезки)+Шаблон;
		Остаток=Сред(ВыводимоеЗначение,ДлинаОбрезки);
		Пока Не ПустаяСтрока(Остаток) Цикл
			Замена=ДокWord.Content.Find;
			Замена.Execute(Шаблон, Ложь, Истина, Ложь,,, Истина,, Ложь, Обрезь);
			
			ВыводимоеЗначение=Остаток;
			Обрезь=лев(ВыводимоеЗначение,ДлинаОбрезки)+Шаблон;
			Остаток=Сред(ВыводимоеЗначение,ДлинаОбрезки);
		КонецЦикла;
		Замена=ДокWord.Content.Find;
		Замена.Execute(Шаблон, Ложь, Истина, Ложь,,, Истина,, Ложь, Обрезь);
		Замена=ДокWord.Content.Find;
		Замена.Execute(Шаблон, Ложь, Истина, Ложь,,, Истина,, Ложь, "");
	Иначе
		Замена=ДокWord.Content.Find;
		//
		Пока Замена.Execute(Шаблон, Ложь, Истина, Ложь,,, Истина,, Ложь, Значение) Цикл
			Замена=ДокWord.Content.Find;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// Процедура заполняет таблицу документа Word
//	ОбъектWord - СОМОбъект - документ Word
//	ВыборкаДанных - выборка запроса или ТаблицаЗначений - собственно чем заполняем
//	ПараметрШаблона - строка формата $$****&& - для поиска и позиционирования на таблице документа. Заполняться будет следующая за строкой параметра таблица.
//	СтруктураПолей - структура - Порядок и количество ключей должно соответствовать порядку и количеству колонок в таблице документа. 
//									Ключ - имя поля в выборке "ВыборкаДанных" для заполнения ячейки
//									Значение - строка - заголовок шаки таблицы, не обязателен, работает только с параметром ЗаполнятьШапку = ИСТИНА
//									Для пропуска колонки используем ключи формата _НеЗаполняемХХ (где хх - произвольные символы или число на случай если пропускаемых колонок несколько).
//	НомерПервойСтроки - число - номер первой строки для заполнения, по умолчанию = 2 т.к. считаем, что первая строка это шапка таблицы
//	ЗаполнятьШапку - булево - признак заполнения шапки, если ИСТИНА, то первая строка таблицы заполняется значениями из структуры "СтруктураПолей" 
//									Для пропуска колонки используем ключи формата _НеЗаполняемШапкуХХ, (!!ячеки данных будут так же пропущены!!), если же ключ формата _НеЗаполняемХХ, то ячейка шапки заполняется.
Процедура ЗаполнитьТаблицуДокумента(ОбъектWord, ВыборкаДанных, ПараметрШаблона, СтруктураПолей, НомерПервойСтроки = 2, ЗаполнятьШапку = Ложь) Экспорт
	
	Если ПустаяСтрока(ПараметрШаблона) Тогда
		Возврат;
	КонецЕсли;
	ВыделенныеДанные = ОбъектWord.ActiveWindow.Selection;
	ВыделенныеДанные.GoTo(-1,, , "Nachalo");//переходим в начало документа
	ВыделенныеДанные.Collapse();
	ОбъектПоиск 				= ВыделенныеДанные.Find;
	ОбъектПоиск.Forward 		= True;
	ОбъектПоиск.MatchWildcards 	= False;
	ОбъектПоиск.Text 			= ПараметрШаблона;
	Пока ОбъектПоиск.Execute() Цикл
		ВыделенныеДанные.Delete();
		ВыделенныеДанные.InsertAfter("");			
		ВыделенныеДанные.GoTo(2, 2, 1, "").Select();//выделяем первую таблицу после параметра
		Попытка
			ТаблицаWord = ВыделенныеДанные.Tables(1);//позиционируемся на таблице в выделении
		Исключение
			Сообщить(" - за параметром "+ПараметрШаблона+" не найдено ни одной таблицы!", СтатусСообщения.Внимание);
			Возврат;
		КонецПопытки;
		
		Если ТаблицаWord.Columns.Count+1 < СтруктураПолей.Количество() Тогда
			Сообщить(" - таблица шаблона "+" содержит "+(ТаблицаWord.Columns.Count()+1)+" колонок, из необходимых "+СтруктураПолей.Количество()+"! Таблица пропущена.", СтатусСообщения.Внимание);
			Возврат;
		КонецЕсли;
		
		СтрокТаблицы = ТаблицаWord.Rows.Count();
		Если СтрокТаблицы < НомерПервойСтроки Тогда
			ДобавитьСтрок = НомерПервойСтроки - СтрокТаблицы;
			ТаблицаWord.Rows(СтрокТаблицы).Select();
			ВыделенныеДанные.InsertRowsBelow(ДобавитьСтрок);
			СтрокТаблицы = ТаблицаWord.Rows.Count();
		КонецЕсли;
		
		Если ЗаполнятьШапку Тогда
			индексКолонки = 1;
			Для каждого ЗаполняемаяКолонка Из СтруктураПолей Цикл
				индексКолонки = индексКолонки + 1;
				Если Найти(НРег(ЗаполняемаяКолонка.Ключ), "_незаполняемшапку") = 0 Тогда
					ТаблицаWord.Cell(1, индексКолонки).Range.Text = Строка(ЗаполняемаяКолонка.Значение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		ТаблицаWord.Rows(СтрокТаблицы).Select();
		
		ЭтоТаблицаЗначений = (ТипЗнч(ВыборкаДанных) = Тип("ТаблицаЗначений"));
		
		НомерСтроки = НомерПервойСтроки;// по умолчанию = 2, т.к. первая строка - шапка
		н = 0;
		КоличествоСтрокДанных = ВыборкаДанных.Количество();
		Для н = 0 По КоличествоСтрокДанных-1 Цикл
			
			Если ЭтоТаблицаЗначений Тогда
				Данные = ВыборкаДанных[н];
			Иначе
				ВыборкаДанных.Следующий();
				Данные = ВыборкаДанных;
			КонецЕсли;
			Если НомерСтроки > СтрокТаблицы Тогда
				ТаблицаWord.Rows(НомерСтроки-1).Select();
				ВыделенныеДанные.InsertRowsBelow();
			КонецЕсли;
			индексКолонки = 1;
			Для каждого ЗаполняемаяКолонка Из СтруктураПолей Цикл
				индексКолонки = индексКолонки + 1;
				Если Найти(НРег(ЗаполняемаяКолонка.Ключ), "_незаполняем") = 0 Тогда
					Если ТипЗнч(Данные[ЗаполняемаяКолонка.Ключ])=Тип("Число") Тогда
						ТаблицаWord.Cell(НомерСтроки, индексКолонки).Range.Text = Формат(Данные[ЗаполняемаяКолонка.Ключ],"ЧДЦ=2; ЧН=-");
					Иначе
						Если НЕ ЗначениеЗаполнено(Данные[ЗаполняемаяКолонка.Ключ]) Тогда
							ТаблицаWord.Cell(НомерСтроки, индексКолонки).Range.Text = "Для всех";
						Иначе
							ТаблицаWord.Cell(НомерСтроки, индексКолонки).Range.Text = Строка(Данные[ЗаполняемаяКолонка.Ключ]);
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			НомерСтроки = НомерСтроки + 1;
			
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

