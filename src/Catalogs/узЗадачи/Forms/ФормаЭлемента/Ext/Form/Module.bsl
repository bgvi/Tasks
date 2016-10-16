﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов	
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ИспользоватьФорматированиеВСодержании = Истина;
		Объект.Автор = Пользователи.ТекущийПользователь();
		Объект.Важность = ПредопределенноеЗначение("Справочник.узВариантыВажностиЗадачи.Обычная");
		Если Объект.ИспользоватьФорматированиеВСодержании Тогда
			ФорматированныйТекст = Параметры.ЗначениеКопирования.Содержание.Получить();
		Конецесли;
		Если Параметры.Свойство("ПараметрыНовойЗадачи") Тогда
			ПараметрыНовойЗадачи = Параметры.ПараметрыНовойЗадачи; 	
			ЗаполнитьЗначенияСвойств(Объект,ПараметрыНовойЗадачи);
		Конецесли;
		Если Параметры.Свойство("ТребоватьЗаполнитьРодителя") Тогда
			ТребоватьЗаполнитьРодителя = Параметры.ТребоватьЗаполнитьРодителя;
		Конецесли;
	Иначе
		
	КонецЕсли;
	УстановитьВидимостьДоступность();
	УстановитьПараметрыИзмененныеОбъекты();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Если Объект.ИспользоватьФорматированиеВСодержании Тогда
		ФорматированныйТекст = ТекущийОбъект.Содержание.Получить();
	Конецесли;
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("СправочникЗадачаЗаписана");
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	Если Объект.ИспользоватьФорматированиеВСодержании Тогда
		ТекущийОбъект.Содержание = Новый ХранилищеЗначения(ФорматированныйТекст, Новый СжатиеДанных(9));
		
		пТекстСодержания = ПолучитьСодержаниеТекстИзФорматированногоТекста();
		ТекущийОбъект.ТекстСодержания = пТекстСодержания;
	Конецесли;	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если ТребоватьЗаполнитьРодителя
		И НЕ ЗначениеЗаполнено(Объект.Родитель) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Ошибка! необходимо указать родителя для задачи";
		Сообщение.Поле = "Объект.Родитель"; //имя реквизита 
		Сообщение.УстановитьДанные(Объект.Родитель); //Ссылка на объект ИБ
		Сообщение.Сообщить();
		Отказ = Истина;
	Конецесли;
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьДоступность()
	Элементы.Родитель.АвтоОтметкаНезаполненного = ТребоватьЗаполнитьРодителя;
	Элементы.Родитель.АвтоВыборНезаполненного = ТребоватьЗаполнитьРодителя;
	Элементы.ГруппаСодержаниеФорматированное.Видимость = Ложь;
	Элементы.ТекстСодержания.Видимость = Ложь;
	Элементы.ГруппаСтраницаИзмененныеОбъектыДетали.Видимость = Ложь;
	Элементы.ГруппаСтраницаСписокИзмененныхОбъектов.Видимость = Ложь;
	Если Объект.ИспользоватьФорматированиеВСодержании Тогда
		Элементы.ГруппаСодержаниеФорматированное.Видимость = Истина;	
	Иначе
		Элементы.ТекстСодержания.Видимость = Истина;
	Конецесли;
	Если ТолькоСписокИзмененныхОбъектов Тогда
		Элементы.ГруппаСтраницаСписокИзмененныхОбъектов.Видимость = Истина;	
	Иначе
	    Элементы.ГруппаСтраницаИзмененныеОбъектыДетали.Видимость = Истина;
	Конецесли;
КонецПроцедуры

&НаСервере
Функция ПолучитьСодержаниеТекстИзФорматированногоТекста() 
	ТекстHTML = "";
	Вложения = Новый Структура;
	ФорматированныйТекст.ПолучитьHTML(ТекстHTML, Вложения);
	
	пТекстСодержания = СтроковыеФункцииКлиентСервер.ИзвлечьТекстИзHTML(ТекстHTML);
	Возврат пТекстСодержания;
КонецФункции 

&НаСервере
Процедура УстановитьПараметрыИзмененныеОбъекты()
	ИзмененныеОбъекты.Параметры.УстановитьЗначениеПараметра("Задача",Объект.Ссылка);
	ИзмененныеОбъекты.Параметры.УстановитьЗначениеПараметра("ЭтоНовый",Объект.Ссылка.Пустая());
	ИзмененныеОбъектыСписок.Параметры.УстановитьЗначениеПараметра("Задача",Объект.Ссылка);
	ИзмененныеОбъектыСписок.Параметры.УстановитьЗначениеПараметра("ЭтоНовый",Объект.Ссылка.Пустая());
КонецПроцедуры 

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы


&НаКлиенте
Процедура КомментарииВКодеОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ФИОИсполнителя = Неопределено;
	Если ЗначениеЗаполнено(Объект.Исполнитель) Тогда
		МассивПодстрок = СтрРазделить(Объект.Исполнитель," ");
		КоличествоСлов = МассивПодстрок.Количество();
		Если КоличествоСлов > 0 Тогда
			ФИОИсполнителя = " "+ МассивПодстрок[0];
		Конецесли;
		Если КоличествоСлов > 1 Тогда
			ФИОИсполнителя = ФИОИсполнителя + " " + Лев(МассивПодстрок[1],1)+".";
		Конецесли;
		Если КоличествоСлов > 2 Тогда
			ФИОИсполнителя = ФИОИсполнителя + "" + Лев(МассивПодстрок[2],1)+".";
		Конецесли;	
	Конецесли;
	//+ Иванов А.Б. 2016-09-07
	//+ #4Иванов Антон. Борисович.2016-09-07
	Объект.КомментарииВКоде = "//+ #"+Объект.Код 
		+ ?(ЗначениеЗаполнено(Объект.НомерВнешнейЗаявки)," "+Объект.НомерВнешнейЗаявки,"")
		+ ФИОИсполнителя
		+ " " + Формат(ТекущаяДата(),"ДФ=yyyy-MM-dd"); 
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПриИзменении(Элемент)
	Объект.СрокИсполнения = КонецДня(Объект.СрокИсполнения);
КонецПроцедуры

&НаКлиенте
Процедура КомментарииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьВводКомментария", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ЭтоДобавлениеКомментария",Истина);
	ОткрытьФорму("Справочник.узЗадачи.Форма.ФормаВводаКомментария",ПараметрыФормы,,,,,ОповещениеОЗакрытии);	
КонецПроцедуры


&НаКлиенте
Процедура ОбработатьВводКомментария(РезультатЗакрытия, ДопПараметры) Экспорт
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	Конецесли;
	Модифицированность = Истина;
	СтрокаКомментарии = Объект.Комментарии.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаКомментарии,РезультатЗакрытия);
	Объект.Комментарии.Сортировать("ДатаКомментария УБЫВ");
КонецПроцедуры 


&НаКлиенте
Процедура КомментарииПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомментарииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Возврат;
	Конецесли;

КонецПроцедуры

&НаКлиенте
Процедура КомментарииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	СтрокаКомментарии = Элементы.Комментарии.ТекущиеДанные;	
	Если СтрокаКомментарии = Неопределено тогда
		Возврат;	
	Конецесли;	
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьВводКомментария", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ДатаКомментария",СтрокаКомментарии.ДатаКомментария);
	ПараметрыФормы.Вставить("Автор",СтрокаКомментарии.Автор);
	ПараметрыФормы.Вставить("Комментарий",СтрокаКомментарии.Комментарий);
	ОткрытьФорму("Справочник.узЗадачи.Форма.ФормаВводаКомментария",ПараметрыФормы,ЭтаФорма,,,,ОповещениеОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
	Элементы.Комментарии.ЗакончитьРедактированиеСтроки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	//ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьОтветНаВопросОЗаписи", ЭтаФорма);
	//ВызватьИсключение "Надо поправить";
	//ПоказатьВопрос(ОповещениеОЗакрытии,"Перед тем как указать исполнителя, необходимо записать задачу. Продолжить?",РежимДиалогаВопрос.ДаНет,,,"Записать задачу?");	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьЗаголовокФормы();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокФормы()
	Заголовок = ?(ЗначениеЗаполнено(Объект.Код), "#"+ Объект.Код+" ", "") + Объект.Наименование;
КонецПроцедуры 

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	ОбновитьЗаголовокФормы();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьФорматированиеВСодержанииПриИзменении(Элемент)
	ПриИзмененииИспользоватьФорматированиеВСодержанииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииИспользоватьФорматированиеВСодержанииНаСервере()
	Если Объект.ИспользоватьФорматированиеВСодержании Тогда
		ФорматированныйТекст = Объект.ТекстСодержания;
	Иначе
		пТекстСодержания = ПолучитьСодержаниеТекстИзФорматированногоТекста();
		Объект.ТекстСодержания = пТекстСодержания;				
	Конецесли;
	УстановитьВидимостьДоступность();	
КонецПроцедуры 

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.ГруппаСтраницаИзмененныеОбъекты Тогда
		УстановитьПараметрыИзмененныеОбъекты();
	Конецесли;
КонецПроцедуры

&НаКлиенте
Процедура ТолькоСписокИзмененныхОбъектовПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

#КонецОбласти

