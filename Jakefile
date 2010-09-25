/*  
 * Jakefile
 * MessageBoard
 *    
 * Copyright (C) 2010 Antoine Mercadal <antoine.mercadal@inframonde.eu>
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


var ENV = require("system").env,
    FILE = require("file"),
	OS = require("os"),
    task = require("jake").task,
    FileList = require("jake").FileList,
    app = require("cappuccino/jake").app,
    configuration = ENV["CONFIG"] || ENV["CONFIGURATION"] || ENV["c"] || "Release";

app ("MessageBoard", function(task)
{
    task.setBuildIntermediatesPath(FILE.join("Build", "MessageBoard.build", configuration));
    task.setBuildPath(FILE.join("Build", configuration));

    task.setProductName("MessageBoard");
    task.setIdentifier("org.archipel.messageboard");
    task.setVersion("1.0");
    task.setAuthor("Antoine Mercadal");
    task.setEmail("antoine.mercadal @nospam@ inframonde.eu");
    task.setSummary("MessageBoard");
    task.setSources(new FileList("*.j", "MessageBoard/*.j"));
    task.setResources(new FileList("Resources/*"));
    task.setInfoPlistPath("Info.plist");

    if (configuration === "Debug")
        task.setCompilerFlags("-DDEBUG -g");
    else
        task.setCompilerFlags("-O");
});


task ("documentation", function(task)
{
   OS.system("doxygen MessageBoard.doxygen")
});

task ("default", ["MessageBoard"]);
task ("docs", ["documentation"]);
task ("all", ["MessageBoard", "documentation"]);
