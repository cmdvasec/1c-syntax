﻿#Использовать logos

Перем Лог;

Процедура ВыполнитьКоманду(Знач КомандаЗапуска, Знач ТекстОшибки = "", Знач РабочийКаталог = "")

	Лог.Информация("Выполняю команду: " + КомандаЗапуска);

	Процесс = СоздатьПроцесс("cmd.exe /C " + ОбернутьВКавычки(КомандаЗапуска), РабочийКаталог, Истина, , КодировкаТекста.UTF8);
	Процесс.Запустить();
	
	Процесс.ОжидатьЗавершения();
	
	Пока НЕ Процесс.Завершен ИЛИ Процесс.ПотокВывода.ЕстьДанные Цикл
		СтрокаВывода = Процесс.ПотокВывода.ПрочитатьСтроку();
		Сообщить(СтрокаВывода);
	КонецЦикла;
	
	Если Процесс.КодВозврата <> 0 Тогда
		Лог.Ошибка("Код возврата: " + Процесс.КодВозврата);
		ВызватьИсключение ТекстОшибки + Символы.ПС + Процесс.ПотокОшибок.Прочитать();
	КонецЕсли;

КонецПроцедуры

Функция ОбернутьВКавычки(Знач Строка);
	Возврат """" + Строка + """";
КонецФункции

Процедура ОбновитьПакетРедактора(ДанныеКоманды)
	
	ВыполнитьКоманду("git pull", , ДанныеКоманды.ПапкаРепозитория);

	ФайлИсточник = Новый Файл(ДанныеКоманды.ПутьКФайлуИсточнику);

	ПутьКФайлуПриемнику = ДанныеКоманды.ПапкаРепозитория;
	Если ЗначениеЗаполнено(ДанныеКоманды.ПоместитьВПапку) Тогда
		ПутьКФайлуПриемнику = ОбъединитьПути(ПутьКФайлуПриемнику, ДанныеКоманды.ПоместитьВПапку);
	КонецЕсли;
	ПутьКФайлуПриемнику = ОбъединитьПути(ПутьКФайлуПриемнику, ФайлИсточник.Имя);

	КопироватьФайл(ДанныеКоманды.ПутьКФайлуИсточнику, ПутьКФайлуПриемнику);

	ВыполнитьКоманду("git add .", , ДанныеКоманды.ПапкаРепозитория);

	ВыполнитьКоманду("git commit -m ""Grammars update " + ФайлИсточник.Имя + """", , ДанныеКоманды.ПапкаРепозитория);

КонецПроцедуры

Функция Конструктор_ДанныеКомандыОбновленияПакета()

	ДанныеКоманды = Новый Структура;

	ДанныеКоманды.Вставить("ПутьКФайлуИсточнику", 	"");
	ДанныеКоманды.Вставить("ПапкаРепозитория", 		"");
	ДанныеКоманды.Вставить("ПоместитьВПапку", 		"");

	Возврат ДанныеКоманды;

КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.app.1c-syntax");
Лог.УстановитьУровень(УровниЛога.Информация);

ИмяКаталогаСборки = "build";
КаталогСборки = ОбъединитьПути(ТекущийКаталог(), ИмяКаталогаСборки);

ПапкаРепозиториев = ОбъединитьПути(ТекущийКаталог(), "..");
ИмяПакета = "language-1c-bsl";

ИмяПапки_Sublime 	= "sublime-" + ИмяПакета;
ИмяПапки_VSC 		= "vsc-" + ИмяПакета;
ИмяПапки_Atom 		= "atom-" + ИмяПакета;

Папка_Sublime 	= ОбъединитьПути(ПапкаРепозиториев, ИмяПапки_Sublime);
Папка_VSC 		= ОбъединитьПути(ПапкаРепозиториев, ИмяПапки_VSC);
Папка_Atom 		= ОбъединитьПути(ПапкаРепозиториев, ИмяПапки_Atom);

ДанныеКоманды_Sublime = Конструктор_ДанныеКомандыОбновленияПакета();
ДанныеКоманды_Sublime.ПутьКФайлуИсточнику = ОбъединитьПути(КаталогСборки, "1c.tmLanguage");
ДанныеКоманды_Sublime.ПапкаРепозитория = Папка_Sublime;

ОбновитьПакетРедактора(ДанныеКоманды_Sublime);

ДанныеКоманды_Sublime.ПутьКФайлуИсточнику = ОбъединитьПути(КаталогСборки, "1c-query.tmLanguage");
ОбновитьПакетРедактора(ДанныеКоманды_Sublime);

ДанныеКоманды_VSC = Конструктор_ДанныеКомандыОбновленияПакета();
ДанныеКоманды_VSC.ПутьКФайлуИсточнику = ОбъединитьПути(КаталогСборки, "1c.tmLanguage");
ДанныеКоманды_VSC.ПапкаРепозитория = Папка_VSC;
ДанныеКоманды_VSC.ПоместитьВПапку = "syntaxes";

ОбновитьПакетРедактора(ДанныеКоманды_VSC);

ДанныеКоманды_VSC.ПутьКФайлуИсточнику = ОбъединитьПути(КаталогСборки, "1c-query.tmLanguage");
ОбновитьПакетРедактора(ДанныеКоманды_VSC);

ДанныеКоманды_Atom = Конструктор_ДанныеКомандыОбновленияПакета();
ДанныеКоманды_Atom.ПутьКФайлуИсточнику = ОбъединитьПути(КаталогСборки, "1c.cson");
ДанныеКоманды_Atom.ПапкаРепозитория = Папка_Atom;
ДанныеКоманды_Atom.ПоместитьВПапку = "grammars";

ОбновитьПакетРедактора(ДанныеКоманды_Atom);

ДанныеКоманды_Atom.ПутьКФайлуИсточнику = ОбъединитьПути(КаталогСборки, "1c-query.cson");
ОбновитьПакетРедактора(ДанныеКоманды_Atom);
