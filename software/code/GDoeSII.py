"""This program computes Fresnel and Fraunhofer diffraction integrasl of phase profiles. This can also convert the phase profiles into 
GDSII file format for lithography applications"""

__author__ = "Raghu Dharmavarapu"
__copyright__ = "Copyright 2018, Raghu Dharmavarapu"
__credits__ = ["Raghu Dharmavarapu"]
__version__ = 1.2
__maintainer__ = "Raghu Dharmavarapu"
__email__ = "raghu1153@gmail.com"
__status__ = "Production"


from tkinter import *
import tkFileDialog
from PIL import ImageTk, Image
import numpy as np
from gdsCAD import core, shapes
from scipy import misc
import os
import time
from tkinter import ttk
from ttk import Progressbar
import pylab as py

#############Instructions################
'''
Change the base_path to the location where you have this .py file and logo.ico file
'''

def resource_path(relative_path):
    """ Get absolute path to resource, works for dev and for PyInstaller """
    try:
        # PyInstaller creates a temp folder and stores path in _MEIPASS,
        # and places our data files in a folder relative to that temp
        # folder named as specified in the datas tuple in the spec file
        base_path = os.path.join(sys._MEIPASS, 'data')
    except Exception:
        # sys._MEIPASS is not defined, so use the original path
        base_path = 'C://Users//Raghu//Desktop//Program Files//Code'

    return os.path.join(base_path, relative_path)

root = Tk()
###Styling###
style = ttk.Style(root)
style.theme_use("clam")
style.configure('Normal.TButton')
style.configure('TButton', foreground='black',background = 'gray',activeforeground = 'SkyBlue1',font = ("calibri 15 bold"),bordercolor = 'blue')
style.configure("TProgressbar", foreground='black', background='forest green')
style.configure('New.TButton', foreground='black',background = 'gray',activeforeground = 'SkyBlue1', font=('calibri bold', 11),bordercolor = 'blue')
style.configure('GDS.TButton', foreground='black',background = 'PeachPuff2',activeforeground = 'SkyBlue1', font=('calibri bold', 9),bordercolor = 'blue')
style.configure('TLabel', foreground='black',background = 'gray',font = ("calibri 13"))
###Starting Window###
root.title('GDoeSII')
root.geometry("720x520") #You want the size of the app to be 620x400
root.iconbitmap(resource_path('logo.ico'))
root.resizable(0, 0) #Don't allow resizing in the x or y direction
fileLoc = StringVar(root)
unit= None
globIm = None
im = None
mode = None
rightFrame = Frame(root, borderwidth = 1, relief = RAISED, padx = 0, pady = 0) 
#rightFrame.pack_propagate(0)
rightFrame.pack(side = RIGHT, pady = 5, fill = X)
rightFrame.bind("<1>", lambda event: rightFrame.focus_set())
leftFrame = Frame(root,relief=SUNKEN, borderwidth=1, pady = 15, padx = 12,bg = 'gray85')
leftFrame.pack(side = LEFT)
leftFrame.bind("<1>", lambda event: leftFrame.focus_set())

####Opening Layout####
rm = Image.open(resource_path('Instructions.png'))
width, height = rm.size
m = max(width,height)
if m > 515:
    scale = 515.0/m
    rm = rm.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
rm = ImageTk.PhotoImage(rm)
redLabel = Label(rightFrame,image = rm)
redLabel.image = rm
redLabel.pack(pady = 10)
def Handler():
    for widget in rightFrame.winfo_children():
        widget.destroy()
    global im
    global fileLoc
    global globIm
    fileLoc = tkFileDialog.askopenfilename(initialdir = "/",title = "Select file",filetypes = (("Supported formats","*.jpg"),("Supported formats","*.png"),("Supported formats","*.jpeg")))
    if fileLoc == "":
        ReadMe()
    else:
        im = Image.open(fileLoc)
        width, height = im.size
        m = max(width,height)
        if m > 330:
            scale = 330.0/m
        else:
            scale = 1
        globIm = im.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
        globIm = ImageTk.PhotoImage(globIm)
        label = Label(rightFrame,image = globIm)
        label.image = globIm
        label.pack(padx = int((420-width*scale)/2))
        rightFrame.pack_propagate(0)
        l2 = Label(rightFrame, text = 'Image loaded... ',relief = RAISED, font = 'calibri 15 bold', fg = 'black').pack(padx = 60, pady = 10) 

def gdsConv(u,m):
    global mode
    global unit
    global globIm
    global im
    rightFrame.pack_propagate(0)
    if im == None:
        for widget in rightFrame.winfo_children():
           widget.destroy()
        l2 = Label(rightFrame, text = ' Import Image first! ',relief = RAISED, font = 'calibri 15 bold', fg = 'red').pack(padx = 140)    
    else:
        if u == "" or (m not in ('2','4','8','16','32','64')) or (not str.isdigit(u)) :
            for widget in rightFrame.winfo_children():
                widget.destroy()
            label = Label(rightFrame,image = globIm)
            label.image = globIm
            label.pack(padx = 60)
            l2 = Label(rightFrame, text = ' Please select valid unit and Layers! ',relief = RAISED, font = 'calibri 15 bold', fg = 'red').pack(padx = 60, pady = 10) 
        else:
            saveLoc =  tkFileDialog.asksaveasfilename()
            if saveLoc == None or saveLoc == "":
                for widget in rightFrame.winfo_children():
                    widget.destroy()
                label = Label(rightFrame,image = globIm)
                label.image = globIm
                label.pack(padx = 60)
                l2 = Label(rightFrame, text = ' Select a save location! ',relief = RAISED, font = 'calibri 15 bold', fg = 'red').pack(padx = 60, pady = 10) 
            else:
                unit = int(u)*1e-9
                mode = int(m)
                for widget in rightFrame.winfo_children():
                        widget.destroy()
                # label = Label(rightFrame,image = globIm)
                # label.image = globIm
                # label.pack(padx = 60)
                ###gdsWriter###
                name = fileLoc.split('/')[-1].split('.')[0]
                width, height = im.size
                cell = core.Cell('GDSII')
                layout = core.Layout(name,unit)
                rows = np.arange(height)
                global imArray
                imArray = misc.imread(fileLoc, flatten= 1)
                maxVal = np.max(imArray)
                minVal = np.min(imArray)
                bins = []
                levels = mode
                for b in range(levels+1):
                    interval = (maxVal-minVal+1)/float(levels)
                    bins.append(minVal+b*interval)
                t = time.time()
                global mask
                mask = np.digitize(imArray, bins)
                ####Shows discritised image###
                digitized = mask*(256/(levels))
                im = Image.fromarray(digitized.astype('uint8'))
                width, height = im.size
                m = max(width,height)
                if m > 330:
                    scale = 330.0/m
                else:
                    scale = 1
                globIm = im.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
                globIm = ImageTk.PhotoImage(globIm)
                label = Label(rightFrame,image = globIm)
                label.image = globIm
                label.pack(padx = int((420-width*scale)/2))
                l2 = Label(rightFrame, text = 'Conversion in progress...',relief = RAISED, font = 'calibri 15 bold', fg = 'blue').pack(padx = 60, pady = 10)
                progress_var = DoubleVar(root)
                progress=Progressbar(rightFrame,orient=HORIZONTAL,variable=progress_var, maximum = 100, length = 290)
                progress.pack(padx = 20)
                for row in rows:
                    k = (float(row)/height)*100
                    progress_var.set(k)
                    time.sleep(0.001)
                    root.update()
                    r = mask[row]
                    col = 0
                    while col < width:
                        i = 0
                        pres = r[col]
                        if r[col + i] == pres and r[col+i] > 1 :
                            while r[col+i] == pres:
                                i = i+1
                                if col + i > width-1:
                                    break
                            cell.add(core.Path([(col,height-row),(col+i,height-row)],pathtype = 0,layer = pres-1))
                            col = col + i
                        else:
                            col = col + 1
                layout.add(cell)
                layout.save(saveLoc+'.gds')
                for widget in rightFrame.winfo_children():
                        widget.destroy()
                label = Label(rightFrame,image = globIm)
                label.image = globIm
                label.pack(padx = 60)
                l2 = Label(rightFrame, text = 'Conversion completed.',relief = RAISED, font = 'calibri 15 bold', fg = 'blue').pack(padx = 60, pady = 10)
                tot = int((time.time() - t))
                m = int(tot/60)
                s  = int(tot%60)
                # message = Listbox(rightFrame,font = 'Times 12', width = 360)
                # message.pack(side = LEFT)
                # message.insert(END,'Time taken: '+str(m)+' minutes and '+str(s)+' seconds')
                # message.insert(END,'Image dimensions: width = '+str(width)+' height = '+str(height))
                # message.insert(END,'Pixel size used: '+str(unit))
                inpSize = os.path.getsize(fileLoc)
                outSize = os.path.getsize(saveLoc+'.gds')
                message = Label(rightFrame,text = 'Conversion time: '+str(m)+' minutes and '+str(s)+' seconds\n'+'Image dimensions: width = '+str(width)+' height = '+str(height)+'\n'+'Pixel size used: '+str(unit*1e9)+' nm\n'+'Input file size: '+str(inpSize/1024)+' KB Output GDSII file size: '+str(outSize/1024)+' KB', anchor=W, justify=LEFT, font = 'calibri 11 bold')
                message.pack(side = LEFT,padx = 5)
def about():
    for widget in rightFrame.winfo_children():
        widget.destroy()
    rm = Image.open(resource_path('Aboutme.png'))
    width, height = rm.size
    m = max(width,height)
    if m > 515:
        scale = 515.0/m
        redme = rm.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
    readme = ImageTk.PhotoImage(redme)
    redLabel = Label(rightFrame,image = readme)
    redLabel.image = readme
    redLabel.pack(pady = 5)
    
def imMaker(path,n):
    rem = Image.open(path)
    width, height = rem.size
    global ret
    scale = 1
    r = rem.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
    ret = ImageTk.PhotoImage(r)
    return ret
    
def ReadMe():
    for widget in rightFrame.winfo_children():
        widget.destroy()
    rm = Image.open(resource_path('Instructions.png'))
    width, height = rm.size
    m = max(width,height)
    if m > 515:
        scale = 515.0/m
        redme = rm.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
    readme = ImageTk.PhotoImage(redme)
    redLabel = Label(rightFrame,image = readme)
    redLabel.image = readme
    redLabel.pack(pady = 10)
    
    
def periodicStructures():
    rightFrame.grid_propagate(0)
    global r
    r = IntVar(root)
    for widget in rightFrame.winfo_children():
        widget.destroy()
    R1 = Radiobutton(rightFrame, text="Triangle", variable=r, value=1,font = 'calibri 12 bold')
    R1.grid(row = 0, column = 0, sticky = W,rowspan = 2,padx = 25)
    R2 = Radiobutton(rightFrame, text="Circle", variable=r, value=2,font = 'calibri 12 bold')
    R2.grid(row = 2, column = 0, sticky = W,rowspan = 2,padx =25)
    R3 = Radiobutton(rightFrame, text="Rectangle", variable=r, value=3,font = 'calibri 12 bold')
    R3.grid(row = 4, column = 0, sticky = W,rowspan = 2,padx = 25)
    ima = imMaker(resource_path('Triangle.png'),122)
    la = Label(rightFrame,image = ima)
    la.imag = ima
    la.grid(row = 0, column = 1, sticky = W,rowspan = 2)
    imb = imMaker(resource_path('Circle.png'),120)
    lb = Label(rightFrame,image = imb)
    lb.imag = imb
    lb.grid(row = 2, column = 1, sticky = W,rowspan = 2)
    imc = imMaker(resource_path('Rectangle.png'),120)
    lc = Label(rightFrame,image = imc)
    lc.imag = imc
    lc.grid(row = 4, column = 1, sticky = W,rowspan = 2)
    ###Triangle
    u2 = Label(rightFrame, text="Base: ", font = ("calibri 12 bold"))
    u2.grid(row = 0, column = 2, sticky = W,padx = 25)#label
    base = IntVar(root)
    v2 = ttk.Entry(rightFrame, textvariable = base, width = 12,cursor = 'xterm')
    v2.grid(row = 0 , column = 3, sticky = W, padx  = 25)#entry textbox
    u3 = Label(rightFrame, text="Height: ", font = ("calibri 12 bold"))
    u3.grid(row = 1, column = 2, sticky = W, padx = 25)#label
    height = IntVar(root)
    v3 = ttk.Entry(rightFrame, textvariable = height, width = 12,cursor = 'xterm')
    v3.grid(row = 1 , column = 3, sticky = W, padx  = 25)#entry textbox  
    ###Circle
    u4 = Label(rightFrame, text="Radius: ", font = ("calibri 12 bold"))
    u4.grid(row = 2, column = 2, sticky = W, padx = 25)#label
    radius = IntVar(root)
    v4 = ttk.Entry(rightFrame, textvariable = radius, width = 12,cursor = 'xterm')
    v4.grid(row = 2 , column = 3, sticky = W, padx  = 25)#entry textbox
    #u5 = Label(rightFrame, text="Eccentricity: ", font = ("calibri 12 bold"))
    #u5.grid(row = 3, column = 2, sticky = W,padx = 15)#label
    #ecc = IntVar(root)
    #v5= Entry(rightFrame, textvariable = ecc, width = 8)
    #v5.grid(row = 3 , column = 3, sticky = W, padx  = 15)#entry textbox    
    #Rectangle
    u6 = Label(rightFrame, text="Length: ", font = ("calibri 12 bold"))
    u6.grid(row = 4, column = 2, sticky = W, padx = 25)#label
    leng = IntVar(root)
    v6 = ttk.Entry(rightFrame, textvariable = leng, width = 12,cursor = 'xterm')
    v6.grid(row = 4 , column = 3, sticky = W, padx  = 25)#entry textbox
    u7 = Label(rightFrame, text="Breadth: ", font = ("calibri 12 bold"))
    u7.grid(row = 5, column = 2, sticky = W,padx  = 25)#label
    breadth = IntVar(root)
    v7= ttk.Entry(rightFrame, textvariable = breadth, width = 12,cursor = 'xterm')
    v7.grid(row = 5 , column = 3, sticky = W,padx = 25)#entry textbox    
    ###Row and Column repetitions
    u8 = Label(rightFrame, text="Rows: ", font = ("calibri 12 bold"))
    u8.grid(row = 6, column = 0, sticky = W,padx  = 25, pady = 15)#label
    rows = IntVar(root)
    v8= ttk.Entry(rightFrame, textvariable = rows, width = 16,cursor = 'xterm')
    v8.grid(row = 6 , column = 1, sticky = W,padx = 10)#entry textbox    
    u9 = Label(rightFrame, text="Columns: ", font = ("calibri 12 bold"))
    u9.grid(row = 6, column = 2, sticky = W,padx  = 25)#label
    cols = IntVar(root)
    v9= ttk.Entry(rightFrame, textvariable = cols, width = 12,cursor = 'xterm')
    v9.grid(row = 6 , column = 3, sticky = W,padx = 25)#entry textbox  
    u10 = Label(rightFrame, text="Period: ", font = ("calibri 12 bold"))
    u10.grid(row = 7, column = 0, sticky = W,padx  = 25, pady = 15)#label
    period = IntVar(root)
    v10= ttk.Entry(rightFrame, textvariable = period, width = 16,cursor = 'xterm')
    v10.grid(row = 7 , column = 1, sticky = W,padx = 10,pady = 10)#entry textbox  
    u11 = Label(rightFrame, text = "Mode:", font = ("calibri 12 bold"))
    u11.grid(row = 7, column = 2,padx = 25,sticky = W)#label
    modeList = ["0","1"]
    modeVar=StringVar(root)
    modeVar.set("0") 
    modMenu = ttk.OptionMenu(rightFrame, modeVar,modeList[0], *modeList)
    modMenu.config(width = 8)
    modMenu.grid(row = 7 , column = 3, sticky = W,padx = 25)

    generate = ttk.Button(rightFrame,text = 'Generate', command = lambda: gdsGenerate(r.get(),v2.get(),v3.get(),v4.get(),v6.get(),v7.get(),v8.get(),v9.get(),v10.get(),modeVar.get()),takefocus=False)
    generate.grid(row = 8,column = 0,sticky = W+E+N+S,pady = 20 )
    m = ''
    message = Label(rightFrame, text = m, font = 'calibri 12 bold', fg = 'red')
    message.grid(row = 8,column = 1,columnspan = 3,sticky = W)
    def gdsGenerate(s,base,height,radius,leng,breadth,rows,cols,period,mod):
        mod = int(mod)

        if s == 0:
            m = 'Select a shape!'
            message.config(text = m)
            message.text = m
        elif s == 1:
            if base == '0' or  (not str.isdigit(base)):    
                m = 'Enter Valid Base value!'
                message.config(text = m, fg = 'red')
                message.text = m
            elif height == '0' or  (not str.isdigit(height)):
                m = 'Enter Valid Height value!'
                message.config(text = m, fg = 'red')
                message.text = m    
            else:
                if rows !=0 and cols != 0 and period !=0 and ( str.isdigit(rows)) and ( str.isdigit(cols)) and ( str.isdigit(period)) :
                    f = f = tkFileDialog.asksaveasfilename()
                    if f ==None:
                        m = 'Choose a save location!'
                        message.config(text = m, fg = 'red')
                        message.text = m  
                    else:
                        cell = core.Cell('Triangle')
                        layout = core.Layout('Triangle',unit = 1e-9)
                        if mod == 0:
                            points = [(0,0),(float(base),0),(float(base)/2.0,float(height))]
                            cell.add(core.Boundary(points))
                            cellArray = core.Cell('TriangleArray')
                            cellArray.add(core.CellArray(cell,int(cols),int(rows),(int(period),int(period))))
                            layout.add(cellArray)
                            layout.save(f+'.gds')
                            m = 'GDSII generated!'
                            message.config(text = m, fg = 'blue')
                            message.text = m  
                        elif mod ==1:
                            height = float(height)
                            rows =int(rows)
                            cols = int(cols)
                            period  = float(period)
                            print 'hi'
                            for i in range(rows):
                                for j in range(cols):
                                    points = [(period*j,i*period),(float(base)+period*j,i*period),(float(base)/2.0+period*j,height+i*period)]
                                    cell.add(core.Boundary(points))
                                
                            layout.add(cell)
                            layout.save(f+'.gds')
                            m = 'GDSII generated!'
                            message.config(text = m, fg = 'blue')
                            message.text = m 
                else:
                    m = 'Enter valid rows, columns and period!'
                    message.config(text = m, fg = 'red')
                    message.text = m 
                    
        elif s == 2:
            if radius == '0' or  (not str.isdigit(radius)):    
                m = 'Enter Valid Radius value!'
                message.config(text = m, fg = 'red')
                message.text = m  
            else:
                if rows !=0 and cols != 0 and period !=0 and ( str.isdigit(rows)) and ( str.isdigit(cols)) and ( str.isdigit(period)) :
                    f = tkFileDialog.asksaveasfilename()
                    if f == None:
                        m = 'Choose a save location!'
                        message.config(text = m, fg = 'red')
                        message.text = m  
                    else:
                        cell = core.Cell('Circle')
                        layout = core.Layout('CircleLayout',unit = 1e-9)
                        if mod == 0:
                            cell.add(shapes.Disk((0,0),float(radius)))
                            cellArray = core.Cell('CircleArray')
                            cellArray.add(core.CellArray(cell,int(cols),int(rows),(int(period),int(period))))
                            layout.add(cellArray)
                            #layout.save(f)
                            layout.save(f+'.gds')
                            m = 'GDSII generated!'
                            message.config(text = m, fg = 'blue')
                            message.text = m  
                        elif mod ==1:
                            radius = float(radius)
                            rows =int(rows)
                            cols = int(cols)
                            period  = float(period)
                            print 'hi'
                            for i in range(rows):
                                for j in range(cols):
                                    cell.add(shapes.Disk((period*j,period*i),float(radius)))
                            layout.add(cell)
                            layout.save(f+'.gds')
                            m = 'GDSII generated!'
                            message.config(text = m, fg = 'blue')
                            message.text = m 
                            
                else:
                    m = 'Enter valid rows, columns and period!'
                    message.config(text = m, fg = 'red')
                    message.text = m 
                
        elif s == 3:
            if leng == '0' or  not (str.isdigit(leng)):    
                m = 'Enter Valid Length value!'
                message.config(text = m, fg = 'red')
                message.text = m
            elif breadth == '0'  or (not str.isdigit(breadth)):
                m = 'Enter Valid Breadth value!'
                message.config(text = m, fg = 'red')
                message.text = m    
            else:
                if rows !=0 and cols != 0 and period !=0 and ( str.isdigit(rows)) and ( str.isdigit(cols)) and ( str.isdigit(period)) :
                    f = tkFileDialog.asksaveasfilename()
                    if f ==None:
                        m = 'Choose a save location!'
                        message.config(text = m, fg = 'red')
                        message.text = m  
                    else:
                        cell = core.Cell('Rectangle')
                        layout = core.Layout('RectangleLayout',1e-9)
                        if mod == 0:
                            cell.add(shapes.Rectangle((0,0),(float(leng),float(breadth))))
                            cellArray = core.Cell('RectangleArray')
                            cellArray.add(core.CellArray(cell,int(cols),int(rows),(int(period),int(period))))
                            layout.add(cellArray)
                            layout.save(f+'.gds')
                            m = 'GDSII generated!'
                            message.config(text = m, fg = 'blue')
                            message.text = m  
                        elif mod == 1:
                            leng = float(leng)
                            breadth = float(breadth)
                            rows =int(rows)
                            cols = int(cols)
                            period  = float(period)
                            print 'hi'
                            for i in range(rows):
                                for j in range(cols):
                                    cell.add(shapes.Rectangle((period*j,period*i),(float(leng)+period*j,float(breadth)+period*i)))
                            layout.add(cell)
                            layout.save(f+'.gds')
                            m = 'GDSII generated!'
                            message.config(text = m, fg = 'blue')
                            message.text = m 
                            
                else:
                    m = 'Enter valid rows, columns and period!'
                    message.config(text = m, fg = 'red')
                    message.text = m

fLoc = None   
iLoc = None  
def diffractiveOptics():
    for widget in rightFrame.winfo_children():
        widget.destroy()
    rightFrame.grid_propagate(0)
    global result0
    global result1
    result0 = None
    result1 = None
    rightFrame.pack_propagate(0)
    def disp(frame, wid, message, fl):
        message = message
        global fLoc
        global im
        global iLoc
        if fl == 0:
            fLoc = tkFileDialog.askopenfilename(initialdir = "/",title = "Select file",filetypes = (("Supported formats","*.jpg"),("Supported formats","*.png"),("Supported formats","*.jpeg")))
        else:
            iLoc = tkFileDialog.askopenfilename(initialdir = "/",title = "Select file",filetypes = (("Supported formats","*.jpg"),("Supported formats","*.png"),("Supported formats","*.jpeg")))
        if fl == 0:
            if fLoc == "" or fLoc == None:
                if fl == 0:
                    m = "Message: Import a phase profile"
                elif fl == 1:
                    m = "Message: "
                message.config(text = m)
                message.text = m
            else:
                for widget in frame.winfo_children():
                    widget.destroy()
                for widget in D22.winfo_children():
                    widget.destroy()
                for widget in D12.winfo_children():
                    widget.destroy()
                global im
                im = Image.open(fLoc)
                width, height = im.size
                m = max(width,height)
                if m > wid:
                    scale = float(wid)/m
                elif fl==1:
                    scale = 1
                im = im.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
                im = ImageTk.PhotoImage(im)
                label = Label(frame,image = im)
                label.image = im
                label.pack()
        else:
            if iLoc == "" or iLoc == None:
                if fl == 0:
                    m = "Message: Import a phase profile"
                elif fl == 1:
                    m = "Message: "
                message.config(text = m)
                message.text = m
            else:
                for widget in frame.winfo_children():
                    widget.destroy()
                for widget in D22.winfo_children():
                    widget.destroy()
                for widget in D12.winfo_children():
                    widget.destroy()
                im = Image.open(iLoc)
                width, height = im.size
                m = max(width,height)
                if m > wid:
                    scale = float(wid)/m
                else:
                    scale = 1
                im = im.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
                im = ImageTk.PhotoImage(im)
                label = Label(frame,image = im)
                label.image = im
                label.pack()

    def ff(frame, wid,z,ind):
        global result0
        global result1
        def resize(event, label, Im, j):
            width, height = Im.size

            global dummy1
            global dummy2
            try:
                Im = Im.crop((50,50,width-50,height-50))
                if max(width,height) > 175:
                    scale = 175.0/max(width,height)
                    im = Im.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
                    im = ImageTk.PhotoImage(im)
                    label.config(image = im)
                    label.image = im
                    if j ==0:
                        dummy1 = Im   
                    else:
                        dummy2 = Im
                else:
                    if j ==0:
                        dummy1 = result1
                        scale = 175.0/max(width,height)
                        im = dummy1.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
                    else:
                        dummy2 = result0
                        scale = 175.0/max(width,height)
                        im = dummy2.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
                    im = ImageTk.PhotoImage(im)
                    label.config(image = im)
                    label.image = im

            except Exception as e: print(e)

        if fLoc == None or fLoc == "":
            m = "Message: Import phase first! "
            message.config(text = m)
            message.text = m
        elif ind == 1:
            for widget in frame.winfo_children():
                widget.destroy()
            userPh=  float(maxPh.get()-minPh.get())
            phaseProfile = misc.imread(fLoc, flatten = 1)
            phaseProfile = (phaseProfile*userPh)/np.max(phaseProfile)
            phaseProfile = np.exp(1j*phaseProfile)
            if iLoc !=None and iLoc != "":
                Amp = misc.imread(iLoc,flatten = 1)
                Amp = Amp * float(maxAmp.get()-minAmp.get())/np.max(Amp)
                if Amp.shape == phaseProfile.shape:
                    phaseProfile = np.multiply(Amp,phaseProfile)
                else:
                    m = "Message: Phase and Intensity should have same size"
                    message.config(text = m, fg = 'red')
                    message.text = m
                    return

            FFT = np.fft.fftshift(np.fft.fft2((phaseProfile)))
            I = np.abs(FFT)
            I = I*I
            I = (np.abs(I)*255/np.max(I))*4
            A = np.angle(FFT)
            result1 = Image.fromarray(I)
            width, height = result1.size
            m = max(width,height)
            if m > wid:
                scale = float(wid)/m
            else:
                scale = 1
            im = result1.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
            im = ImageTk.PhotoImage(im)
            label = Label(frame,image = im,cursor = 'sizing')
            label.image = im
            label.pack()
            label.focus_force()
            global dummy1
            dummy1 = result1
            label.bind("<Button 1>", lambda event: resize(event,label,dummy1,0))
            
        elif ind == 0:
            for widget in frame.winfo_children():
                widget.destroy()
            userPh=  float(maxPh.get()-minPh.get())
            phaseProfile = misc.imread(fLoc, flatten = 1)
            un = px.get()
            (width,height) = phaseProfile.shape
            w = int(width*un)
            h = int(height*un)
            phaseProfile = (phaseProfile*userPh)/np.max(phaseProfile)
            phaseProfile = np.exp(1j*phaseProfile)
            if iLoc !=None and iLoc != "":
                Amp = misc.imread(iLoc,flatten = 1)
                Amp = Amp * float(maxAmp.get()-minAmp.get())/np.max(Amp)
                if Amp.shape == phaseProfile.shape:
                    phaseProfile = np.multiply(Amp,phaseProfile)
                else:
                    m = "Message: Phase and Intensity should have same size"
                    message.config(text = m, fg = 'red')
                    message.text = m
                    return
            points1 = np.linspace(-w/2,w/2,int(width)) 
            points2 = np.linspace(h/2,-h/2,int(height)) 
            x,y = np.meshgrid(points2 , points1)
            k = 2*np.pi/wl.get()
            z = z*1e6
            quadratic = np.exp(1j * k * ((x**2 + y**2) / (2*z)))
            img = np.multiply(phaseProfile,quadratic)
            FFT = (np.fft.fftshift(np.fft.fft2((img))))
            I = np.abs(FFT)
            I = I*I
            I = (np.abs(I)*255/np.max(I))*2
            A = np.angle(FFT)
            result0 = Image.fromarray(I)
            width, height = result0.size
            m = max(width,height)
            if m > wid:
                scale = float(wid)/m
            else:
                scale = 1
            im = result0.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
            im = ImageTk.PhotoImage(im)
            label = Label(frame,image = im,cursor = 'sizing')
            label.image = im
            label.pack()
            label.focus_force()
            global dummy2
            dummy2 = result0
            label.bind("<Button 1>", lambda event: resize(event,label,dummy2,1))  
    def saveFig(ind):
        global result0
        global result1
        if ind == 0:
            if result0 == None:
                m = "Message: Compute Fresnel first!"
                message.config(text = m)
                message.text = m
            else:
                sL = tkFileDialog.asksaveasfilename()
                if sL != None or sL != "":
                    py.imsave(sL+'.png',result0)
                else: 
                    pass
        elif ind == 1:
            if result1 == None:
                m = "Message: Compute Farfield first!"
                message.config(text = m)
                message.text = m
            else:
                sL = tkFileDialog.asksaveasfilename()
                if sL != None or sL != "":
                    py.imsave(sL+'.png',result1)
                else: 
                    pass
    Label(rightFrame,text = 'Parameters', justify = CENTER, font = ('calibri 12 bold underline')).grid(row = 0, column = 0, padx = 5)
    Label(rightFrame,text = 'Input Plane', justify = CENTER, font = ('calibri 12 bold underline')).grid(row = 0, column = 1, padx = 50)
    Label(rightFrame,text = 'Output Plane', justify = CENTER, font = ('calibri 12 bold underline')).grid(row = 0, column = 2, padx = 60, columnspan = 3)
    B11 = ttk.Button(rightFrame, text = 'Upload Phase', command = lambda: disp(D11,175, message, 0), takefocus=False, style ='New.TButton',width = 15)
    B11.grid(row = 1, column = 1)
    D11 = Frame(rightFrame)
    D11.grid(row = 2, column = 1,sticky = W+E+N+S, rowspan = 7)
    B21 = ttk.Button(rightFrame, text = 'Upload Intensity',command = lambda: disp(D21,175, message, 1), takefocus=False,style ='New.TButton', width = 15)
    B21.grid(row = 9, column = 1)
    D12 = Frame(rightFrame)
    D12.grid(row = 2, column = 2,sticky = W+E+N+S,columnspan = 2, rowspan = 7)
    D21 = Frame(rightFrame)
    D21.grid(row = 10, column = 1,sticky = W+E+N+S, rowspan = 5)
    D22 = Frame(rightFrame)
    D22.grid(row = 10, column = 2,sticky = W+E+N+S, columnspan = 2, rowspan = 5)
    Label(rightFrame,text = 'Wavelength (nm)').grid(row = 1, column = 0, sticky = W, pady = 3)
    wl = IntVar(root)
    wl.set(633)
    ttk.Entry(rightFrame, textvariable = wl,width = 15,cursor = 'xterm').grid(row = 2, column = 0, sticky = W, pady = 3)
    Label(rightFrame,text = 'Pixel size (nm)').grid(row = 3, column = 0, sticky = W, pady = 3)
    px = IntVar(root)
    px.set(1000)
    ttk.Entry(rightFrame, textvariable = px,width = 15,cursor = 'xterm').grid(row = 4, column = 0, sticky = W, pady = 3)
    Label(rightFrame,text = 'Min Phase (rad)').grid(row = 5, column = 0, sticky = W, pady = 3)
    global minPh
    minPh = DoubleVar(root)
    minPh.set(0)
    ttk.Entry(rightFrame, textvariable = minPh,width = 15,cursor = 'xterm').grid(row = 6, column = 0, sticky = W, pady = 3)
    Label(rightFrame,text = 'Max Phase (rad)').grid(row = 7, column = 0, sticky = W, pady = 3)
    global maxPh
    maxPh = DoubleVar(root)
    maxPh.set(round(2*np.pi,2))
    ttk.Entry(rightFrame, textvariable = maxPh,width = 15,cursor = 'xterm').grid(row = 8, column = 0, sticky = W, pady = 2)
    Label(rightFrame,text = 'Min Amplitude').grid(row = 10, column = 0, sticky = W, pady = 2)
    global minAmp
    minAmp = IntVar(root)
    minAmp.set(0)
    ttk.Entry(rightFrame, textvariable = minAmp,width = 15,cursor = 'xterm').grid(row = 11, column = 0, sticky = W, pady = 2)
    Label(rightFrame,text = 'Max Amplitude').grid(row = 12, column = 0, sticky = W, pady = 2)
    global maxAmp
    maxAmp = DoubleVar(root)
    maxAmp.set(1)
    ttk.Entry(rightFrame, textvariable = maxAmp,width = 15,cursor = 'xterm').grid(row = 13, column = 0, sticky = W, pady = 2)
    B12 = ttk.Button(rightFrame, text = 'Fresnel at z (mm):', command = lambda: ff(D12,175,z.get(),0),takefocus=False, style ='New.TButton')
    B12.grid(row = 1, column = 2)
    z = DoubleVar(root)
    z.set(1)
    Z = ttk.Entry(rightFrame, textvariable = z,width = 8,cursor = 'xterm')
    Z.grid(row = 1, column = 3, sticky = W)
    saveIcon = Image.open(resource_path('saveIcon.png'))
    saveIcon = saveIcon.resize((30,30), Image.ANTIALIAS)
    saveIcon = ImageTk.PhotoImage(saveIcon)
    sb1 = ttk.Button(rightFrame, image = saveIcon, command = lambda: saveFig(0),takefocus=False, style = 'Normal.TButton', padding = "0 0 0 0", cursor = 'hand2')
    sb1.image = saveIcon
    sb1.grid(row = 1, column = 4, sticky = W)
    B22 = ttk.Button(rightFrame, text = 'Compute Farfield',command = lambda: ff(D22,175,0, 1), takefocus=False, style ='New.TButton' )
    #B22.configure(font = 'calibri 12 bold')
    B22.grid(row = 9, column = 2, columnspan = 2)
    sb2 = ttk.Button(rightFrame, image = saveIcon, command = lambda: saveFig(1),takefocus=False, style = 'Normal.TButton', padding = "0 0 0 0", cursor = 'hand2')
    sb2.image = saveIcon
    sb2.grid(row = 9, column = 4, sticky = W)
    m = "Message: "
    message = Label(rightFrame, text = m, font = ("calibri 12 bold"), fg = 'blue')
    message.pack(side = LEFT, anchor = S)
    message.text = m
    conv = ttk.Button(rightFrame,text = 'Convert to GDSII',command = lambda: gdsConv2(v.get(),dropVar.get(),fLoc,message), takefocus=False, style ='GDS.TButton')
    conv.pack(side = RIGHT, anchor = S, padx = 5)

def gdsConv2(u,m,fLoc,message):
    global mode
    global unit
    rightFrame.pack_propagate(0)
    if fLoc == None or fLoc == "":
        m = 'Message: Import Image first! '
        message.config(text = m)
        message.text = m
    else:
        imArray = misc.imread(fLoc, flatten= 1)
        im = Image.open(fLoc)
        width, height = im.size
        m2 = max(width,height)
        if m2 > 330:
            scale = float(330)/m2
        else:
            scale = 1
        im = im.resize((int(width*scale), int(height*scale)), Image.ANTIALIAS)
        im = ImageTk.PhotoImage(im)
        if u == "" or (m not in ('2','4','8','16','32','64')) or (not str.isdigit(u)) :
            m = 'Message: Please select valid unit and levels! '
            message.config(text = m)
            message.text = m
        else:
            saveLoc =  tkFileDialog.asksaveasfilename()
            if saveLoc == None or saveLoc == "":
                m = 'Message: Please select a save location! '
                message.config(text = m)
                message.text = m
            else:
                unit = int(u)*1e-9
                mode = int(m)
                #global im
                for widget in rightFrame.winfo_children():
                        widget.destroy()
                label = Label(rightFrame,image = im)
                label.image = im
                label.pack(padx = 60)
                l2 = Label(rightFrame, text = 'Conversion in progress...',relief = RAISED, font = 'calibri 15 bold', fg = 'blue').pack(padx = 60, pady = 10)
                ###gdsWriter###
                name = fLoc.split('/')[-1].split('.')[0]
                cell = core.Cell('GDSII')
                layout = core.Layout(name,unit)
                rows = np.arange(height)
                maxVal = np.max(imArray)
                minVal = np.min(imArray)
                bins = []
                levels = mode
                for b in range(levels+1):
                    interval = (maxVal-minVal+1)/float(levels)
                    bins.append(minVal+b*interval)
                t = time.time()
                progress_var = DoubleVar(root)
                progress=Progressbar(rightFrame,orient=HORIZONTAL,variable=progress_var, maximum = 100, length = 290)
                progress.pack(padx = 20)
                mask = np.digitize(imArray, bins)
                for row in rows:
                    k = (float(row)/height)*100
                    progress_var.set(k)
                    time.sleep(0.001)
                    root.update()
                    r = mask[row]
                    col = 0
                    while col < width:
                        i = 0
                        pres = r[col]
                        if r[col + i] == pres and r[col+i] > 1 :
                            while r[col+i] == pres:
                                i = i+1
                                if col + i > width-1:
                                    break
                            cell.add(core.Path([(col,height-row),(col+i,height-row)],pathtype = 0,layer = pres-1))
                            col = col + i
                        else:
                            col = col + 1
                layout.add(cell)
                layout.save(saveLoc+'.gds')
                for widget in rightFrame.winfo_children():
                        widget.destroy()
                label = Label(rightFrame,image = im)
                label.image = im
                label.pack(padx = 60)
                l2 = Label(rightFrame, text = 'Conversion completed.',relief = RAISED, font = 'calibri 15 bold', fg = 'blue').pack(padx = 60, pady = 10)
                tot = int((time.time() - t))
                m = int(tot/60)
                s  = int(tot%60)
                inpSize = os.path.getsize(fLoc)
                outSize = os.path.getsize(saveLoc+'.gds')
                mess = Label(rightFrame,text = 'Conversion time: '+str(m)+' minutes and '+str(s)+' seconds\n'+'Image dimensions: width = '+str(width)+' height = '+str(height)+'\n'+'Pixel size used: '+str(unit*1e9)+' nm\n'+'Input file size: '+str(inpSize/1024)+' KB Output GDSII file size: '+str(outSize/1024)+' KB', anchor=W, justify=LEFT, font = 'calibri 11 bold')
                mess.pack(side = LEFT,padx = 5)



#####Main Layout and Buttons######
readMe =ttk.Button(leftFrame,text = 'Read Me', command =  ReadMe,width = 14, takefocus=False)
readMe.grid(row = 0,column = 0, columnspan= 2,padx = 10, pady = 20)
periodic = ttk.Button(leftFrame,text = 'Periodic shapes',command =  periodicStructures, width = 14, takefocus=False)
periodic.grid(row = 1,column = 0, columnspan= 2)
doe = ttk.Button(leftFrame,text = 'DOE', command =  diffractiveOptics, width = 14,  takefocus=False)
doe.grid(row = 2,column = 0, columnspan= 2,pady = 20)
imp = ttk.Button(leftFrame,text = 'Import File', command =  Handler, width = 14, takefocus=False)
imp.grid(row = 3,column = 0, columnspan= 2)
u = ttk.Label(leftFrame, text="Unit (nm): ")
u.grid(row = 4, column = 0,pady = 20)#label
v = ttk.Entry(leftFrame, textvariable = unit, width = 8,cursor = 'xterm')
v.grid(row = 4 , column = 1)#entry textbox
u1 = ttk.Label(leftFrame, text = "Levels:        ")
u1.grid(row = 5, column = 0, pady = 0)#label
optionList = ["2","4","8","16","32","64"]
dropVar=StringVar(root)
dropVar.set(2)
popupMenu = ttk.OptionMenu(leftFrame, dropVar,optionList[0], *optionList)
popupMenu.config(width=4)
popupMenu.grid(row = 5 , column = 1)
conv = ttk.Button(leftFrame,text = 'Convert to GDSII', command = lambda: gdsConv(v.get(),dropVar.get()), takefocus=False)
conv.grid(row = 6,column = 0, pady = 20, columnspan = 2)
periodic = ttk.Button(leftFrame,text = 'About', command =  about,width = 14, takefocus=False)
periodic.grid(row = 7,column = 0, columnspan= 2,pady = 0)

root.mainloop()